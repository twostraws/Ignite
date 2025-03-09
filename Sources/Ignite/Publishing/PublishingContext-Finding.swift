//
// PublishingContext-Finding.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Recurse content root, resolving symbolic links and selecting files by suffix.
struct ContentFinder: Sendable {
    // no configuration, so no need for alternative instances
    static let shared = ContentFinder()

    private let isLinkKey = Set([URLResourceKey.isSymbolicLinkKey])
    private let resourceKeys = Article.resourceKeys
        + [.isDirectoryKey, .isSymbolicLinkKey]
    private let directoryListOptions: FileManager.DirectoryEnumerationOptions = [
        .skipsHiddenFiles,
        .skipsPackageDescendants, // shouldn't be packages in our tree...
        .skipsSubdirectoryDescendants // one directory level per enumerator
    ]

    /// Find content input for a  content maker: recurse from content root, resolve symbolic links,
    /// and make content for any file matching a suffix (case-insensitively).
    ///
    /// The content maker gets a `DeployContent` with the logical deployment path:
    /// - A deploy path is relative to the root and uses `/` as the name separator (like a URL path)
    /// - For symbolic links, use the link name for constructing the deploy path and checking suffixes.
    /// - The name used for a content file deploy path is exclusive of the suffix matched.
    ///
    /// Limitations:
    /// - Does not detect duplicate deploy-paths (because content might use metadata path)
    ///
    /// - Parameters:
    ///   - root: URL for readable directory (with `file:` scheme)
    ///   - suffixes: non-empty Array of non-empty String; content name must end with a suffix
    ///   - contentMaker: closure taking ``DeployContent`` and returning false to halt
    /// - Throws: when root is not a `file:` scheme URL, when suffixes array or values are empty,
    ///   when URL operations fail, or when a directory is encountered again (due to symbolic links)
    func find(
        // swiftlint:disable:previous function_body_length
        // lint exception: using local closures to break up logic
        root: URL,
        suffixes: [String] = [".md"],
        contentMaker: (DeployContent) throws -> Bool
    ) throws {
        enum ParameterError: Error {
            case notFileURL(URL), noSuffixes, emptySuffix
            case directorySeen(next: DeployPath, prior: DeployPath)
        }
        guard root.isFileURL else { throw ParameterError.notFileURL(root) }
        guard !suffixes.isEmpty else { throw ParameterError.noSuffixes }
        guard suffixes.first(where: { $0.isEmpty }) == nil else {
            throw ParameterError.emptySuffix
        }
        // Manage recursion directly, produce logical paths for symbolic links.
        // One element per directory remaining to traverse
        var roots = [DeployPath]()

        // Avoid infinite loops by not adding roots already seen
        // One element per dir added in roots
        var directoriesSeen = [URL: DeployPath]()

        func addRootIfUnseen(_ root: DeployPath) throws {
            let key = root.url.standardizedFileURL
            if let prior = directoriesSeen[key] {
                throw ParameterError.directorySeen(next: root, prior: prior)
            }
            directoriesSeen[key] = root
            roots.append(root)
        }

        // pop last root and make directory enumerator, if available
        func nextDeployEnumerator() -> (deploy: DeployPath, FileManager.DirectoryEnumerator)? {
            guard !roots.isEmpty else { return nil }
            let deploy = roots.removeLast()
            return FileManager.default.enumerator(
                at: deploy.url,
                includingPropertiesForKeys: resourceKeys,
                options: directoryListOptions
            ).map { (deploy, $0) }
        }

        // Verify name ends with suffix (case-insensitively) and strip suffix.
        // non-nil result is not empty.
        func makeDeployName(_ name: String) -> String? {
            Self.suffixStart(name: name, suffixes: suffixes).map {
                String(name[name.startIndex ..< $0])
            }
        }

        try addRootIfUnseen(.init(root, path: ""))

        let resourceSet = Set(resourceKeys)

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
                let resources = try next.resourceValues(forKeys: resourceSet)
                if let isDir = resources.isDirectory, isDir {
                    try addRootIfUnseen(deploy.child(next, name: name))
                    continue
                }
                // skip unless it ends with suffix, and strip suffix from name
                guard let deployName = makeDeployName(name) else {
                    continue
                }

                let content = DeployContent(
                    url: next,
                    path: deploy.child(next, name: deployName).path,
                    resourceValues: resources
                )
                if try !contentMaker(content) {
                    break outer
                }
            }
        }
    }

    /// Find start index of first matching suffix, ignoring case (if any)
    /// - Parameters:
    ///   - name: String to search in
    ///   - suffixes: Array of String suffixes to search
    /// - Returns: String.Index into name of first character of first suffix to match
    static func suffixStart(
        name: String,
        suffixes: [String]
    ) -> String.Index? {
        let options: String.CompareOptions
            = [.backwards, .anchored, .caseInsensitive]
        for suffix in suffixes {
            let range = name.range(of: suffix, options: options)
            if let range, range.upperBound == name.endIndex,
               range.lowerBound > name.startIndex { // not empty
                return range.lowerBound
            }
        }
        return nil
    }

    struct DeployContent {
        let url: URL
        let path: String
        let resourceValues: URLResourceValues
    }

    struct DeployPath: Sendable, CustomStringConvertible {
        let url: URL
        /// Deploy paths start with the root name
        /// and use `/` as the name/segment separator (like URL path)
        let path: String
        var description: String {
            "\n-  url: \(url.absoluteString)\n- path: \(path)"
        }

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
