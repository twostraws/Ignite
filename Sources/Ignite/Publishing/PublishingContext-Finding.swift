//
// File.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Recurse content root, resolving symbolic links and selecting files by suffix.
struct ContentFinder {
    // package clients & no configuration, so no need for alternative instances
    static let shared = ContentFinder()

    private let isLinkKey = Set([URLResourceKey.isSymbolicLinkKey])
    private let resourceKeys = Content.resourceKeys
        + [.isDirectoryKey, .isSymbolicLinkKey]
    private let dirListOptions: FileManager.DirectoryEnumerationOptions = [
      .skipsHiddenFiles,
      .skipsPackageDescendants, // shouldn't be packages in our tree...
      .skipsSubdirectoryDescendants // one directory level per enumerator
    ]

    /// Find content input for a  content maker (and manage deploy path):
    /// recurse from content root, resolve symbolic links, forward files matching any suffix.
    ///
    /// - For symbolic links, use the link name for constructing the deploy path and checking suffixes.
    /// - The name used for the file deploy path is exclusive of the suffix matched.
    ///
    /// Limitations:
    /// - Does not detect or avoid symbolic-link cycles
    /// - Mixing errors for input, url/resource, and contentMaker
    ///
    /// - Parameters:
    ///   - root: URL for readable directory
    ///   - suffixes: non-empty Array of non-empty String; one must be the suffix of the filename
    ///   - contentMaker: closure taking ``DeployContent`` and returning false to halt
    func find(
        root: URL,
        suffixes: [String] = [".md", ".MD"],
        contentMaker: (DeployContent) throws -> Bool
    ) throws {
        enum ProgramError: Error {
            case notFileUrl, noSuffixes, emptySuffix
        }
        guard root.isFileURL else { throw ProgramError.notFileUrl }
        guard !suffixes.isEmpty else { throw ProgramError.noSuffixes }
        guard nil == suffixes.first(where: {$0.isEmpty}) else {
            throw ProgramError.emptySuffix
        }
        // Manage recursion directly to manage logical paths via links
        var roots = [DeployPath]() // one per directory

        func nextDeployEnumerator(
        ) -> (deploy: DeployPath, FileManager.DirectoryEnumerator)? {
          guard !roots.isEmpty else { return nil }
          let deploy = roots.removeLast()
          return FileManager.default.enumerator(
            at: deploy.url,
            includingPropertiesForKeys: resourceKeys,
            options: dirListOptions
          ).map { (deploy, $0) }
        }

        roots.append(.init(root, path: ""))

        let resrcSet = Set(resourceKeys)
        outer:
        while let (deploy, enumerator) = nextDeployEnumerator() { // dir
            while let url = enumerator.nextObject() as? URL { // file, dir
                // resolve symbolic links to get correct resource values
                let linkValue = try url.resourceValues(forKeys: isLinkKey)
                let isLink = linkValue.isSymbolicLink ?? false
                let next = !isLink ? url : url.resolvingSymlinksInPath()
                let name = url.lastPathComponent // use link name for dir path
                _ = consume url // signal error if used instead of next

                // add to roots/enumerator if directory
                let resources = try next.resourceValues(forKeys: resrcSet)
                if let isDir = resources.isDirectory, isDir {
                    roots.append(deploy.child(next, name: name))
                    continue
                }
                // skip unless suffix, then strip suffix from name
                let suffix = suffixes.first { name.hasSuffix($0) }
                guard let suffix else { continue }
                let end = name.index(name.endIndex, offsetBy: -suffix.count)
                let deployName = String(name[name.startIndex ..< end])

                let content = DeployContent(
                    url: next,
                    path: deploy.child(next, name: deployName).path,
                    resourceValues: resources
                )
                if !(try contentMaker(content)) {
                    break outer
                }
            }
        }
    }

    public struct DeployContent {
        public let url: URL
        public let path: String
        public let resourceValues: URLResourceValues
    }

    private struct DeployPath {
        let url: URL
        let path: String
        init(_ url: URL, path: String) {
            self.url = url
            self.path = path
        }
        /// Build next subdirectory or the path to a file
        /// - Parameters:
        ///   - child: URL to child (i.e., with any symbolic link resolved to actual path)
        ///   - name: String segment of path (use link name, not resolved target name)
        /// - Returns: DeployPath for child
        func child(_ child: URL, name: String) -> DeployPath {
            .init(child, path: "\(path)/\(name)")
        }
    }
}
