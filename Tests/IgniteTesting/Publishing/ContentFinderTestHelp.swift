//
// ContentFinderTestHelp.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

@testable import Ignite

extension ContentFinderTests {
    /// Generates markdown header and bullet list per specification.
    enum MdHeaderList {
        case head(level: Int, sort: Bool, skipEmpty: Bool)
        case h2Quiet
        case h2SortQuiet

        /// Generates a markdown section with an optional header and bullet list.
        /// - Parameters:
        ///   - header: Optional section header text
        ///   - items: List items to format as bullets
        /// - Returns: Formatted markdown string
        func generateMarkdownSection<T: StringProtocol>(
            header: T? = nil,
            items: [T]
        ) -> String {
            let (_, shouldSort, shouldSkipEmpty) = headerConfiguration
            if items.isEmpty && shouldSkipEmpty { return "" }

            let (headerPrefix, bulletPrefix) = generatePrefixes(header: header, hasItems: !items.isEmpty)
            var output = ""

            if let headerPrefix, let header {
                output += headerPrefix
                output += header
            }

            guard let bulletPrefix, !items.isEmpty else { return output }
            output += bulletPrefix

            let formattedItems = shouldSort ? items.sorted() : items
            output += formattedItems.joined(separator: bulletPrefix)
            return output
        }

        /// Configuration for header level, sorting, and empty list handling
        private var headerConfiguration: (level: Int, shouldSort: Bool, shouldSkipEmpty: Bool) {
            // swiftlint:disable:previous large_tuple
            switch self {
            case let .head(level, sort, skip): (level, sort, skip)
            case .h2Quiet: (2, false, true)
            case .h2SortQuiet: (2, true, true)
            }
        }

        /// Generates markdown prefixes for header and bullet list
        private func generatePrefixes<T: StringProtocol>(
            header: T?,
            hasItems: Bool
        ) -> (header: String?, bullet: String?) {
            let (level, _, shouldSkipEmpty) = headerConfiguration
            if shouldSkipEmpty, !hasItems { return (nil, nil) }

            var headerPrefix: String?
            if let header, !header.isEmpty {
                headerPrefix = "\n\(String(repeating: "#", count: level)) "
            }

            return (headerPrefix, hasItems ? "\n- " : nil)
        }
    }
}

extension ContentFinderTests {
    /// Set up``FileItem`` in filesystem using ``Files``
    struct FileItemMaker {
        /// Root directory for all items made
        let baseDirectory: URL

        /// Set up``FileItem`` in filesystem using ``Files``
        /// - Parameter item: ``FileItem`` to create
        /// - Returns: ``Files/FoundURL`` indicating made, found, blocked, etc.
        @discardableResult
        func make(_ item: FileItem) throws -> Files.FoundURL {
            switch item {
            case let .root(name):
                let url = Files.makeDirectoryURL(baseDirectory, path: name)
                return try Files.makeDirectory(at: url)
            case .file:
                let url = Files.makeFileURL(baseDirectory, path: item.path)
                return try Files.makeFile(at: url)
            case .directory:
                let url = Files.makeDirectoryURL(baseDirectory, path: item.path)
                return try Files.makeDirectory(at: url)
            case let .link(source, destination):
                let source = Files.makeFileURL(baseDirectory, path: source.path)
                let destination = Files.makeFileURL(baseDirectory, path: destination.path)
                do {
                    try Files.createSymlink(source: source, destination: destination)
                } catch let Files.SymlinkError.symlinkCreationFailed(source, _, _) {
                    return (true, source)
                }
                return (false, source)
            }
        }
    }
}

extension ContentFinderTests.FileItem: CustomStringConvertible {
    var description: String {
        "\(label)(\(name)\(parent.map { " in: \($0.path)" } ?? ""))"
    }
}

extension ContentFinderTests.FileItem {
    var isFile: Bool { Self.fileN == index0 }
    /// Constants for ``index0`` also track ``labels``
    static let (rootN, fileN, dirN, linkN) = (0, 1, 2, 3)

    static let labels = ["root", "file", "dir", "link"]

    private var index0: Int {
        switch self {
        case .root: Self.rootN
        case .file: Self.fileN
        case .directory: Self.dirN
        case .link: Self.linkN
        }
    }

    var name: String {
        switch self {
        case let .root(name): name
        case let .file(name, _), let .directory(name, _): name
        case let .link(source, _): source.name
        }
    }

    var parent: Self? {
        switch self {
        case .root: nil
        case let .file(_, parent), let .directory(_, parent): parent
        case let .link(source, _): source.parent
        }
    }

    var label: String { Self.labels[index0] }

    /// Detect first matching suffix (if any), using the same implementation as ``ContentFinder``,
    /// in order to predict deploy paths discovered during content-finding.
    ///
    /// - Parameter suffixes: Array of String possible suffixes
    /// - Returns: First matchin input, if any.
    func firstMatchingFileSuffix(_ suffixes: [String]) -> String? {
        guard
            isFile,
            let index = ContentFinder.suffixStart(
                name: name,
                suffixes: suffixes
            )
        else {
            return nil
        }
        return String(name[index...])
    }

    // full deploy path
    var path: String {
        switch self {
        case let .root(name): name
        case let .file(name, parent): "\(parent.path)/\(name)"
        case let .directory(name, parent): "\(parent.path)/\(name)"
        case let .link(source, _): source.path
        }
    }
}

extension ContentFinderTests {
    /// Implement filesystem as required to set up ``FileItem``
    enum Files {
        // swiftlint:disable:next nesting
        typealias FoundURL = (found: Bool, url: URL)

        static func isReachable(_ url: URL, check: Bool = true) -> Bool {
            if let reachable = try? url.checkResourceIsReachable() {
                return reachable == check
            }
            return false
        }

        static func makeFile(at url: URL) throws -> FoundURL {
            if isReachable(url) { return (true, url) }
            try "".write(to: url, atomically: true, encoding: .utf8)
            return (false, url)
        }

        static func makeDirectory(at url: URL, clear: Bool = true) throws -> FoundURL {
            let manager = FileManager.default
            var reachable = isReachable(url)
            if reachable {
                if clear {
                    try delete(url)
                    reachable = isReachable(url)
                }
                if reachable {
                    return (true, url)
                }
            }
            try manager.createDirectory(at: url, withIntermediateDirectories: false)
            return (false, url)
        }

        static func makeDirectoryURL(_ baseDirectory: URL, path: String) -> URL {
            makeURL(baseDirectory, path, isFile: false)
        }

        static func makeFileURL(_ baseDirectory: URL, path: String) -> URL {
            makeURL(baseDirectory, path, isFile: true)
        }

        private static func makeURL(
            _ directory: URL,
            _ path: String,
            isFile: Bool
        ) -> URL {
            directory.appending(
                components: path,
                directoryHint: isFile ? .isDirectory : .notDirectory
            )
        }

        static func delete(_ url: URL) throws {
            try FileManager.default.removeItem(at: url)
        }

        static func makeTempDirectory(
            name: String
        ) throws -> FoundURL {
            let manager = FileManager.default
            let url = manager.temporaryDirectory.appending(
                component: name,
                directoryHint: .isDirectory
            )
            return try makeDirectory(at: url)
        }

        static func createSymlink(source: URL, destination: URL) throws {
            if !source.isFileURL {
                throw SymlinkError.sourceNotFileURL(source)
            }
            if !destination.isFileURL {
                throw SymlinkError.destinationNotFileURL(destination)
            }
            if isReachable(destination, check: false) {
                throw SymlinkError.destinationDoesNotExist(destination)
            }
            if isReachable(source) {
                throw SymlinkError.sourceAlreadyExists(source)
            }
            do {
                let manager = FileManager.default
                try manager.createSymbolicLink(at: source, withDestinationURL: destination)
            } catch {
                throw SymlinkError.symlinkCreationFailed(source: source, destination: destination, error: error)
            }
        }

        /// Thrown by ``createSymlink(source:, destination:)``
        enum SymlinkError: Error {
            // swiftlint:disable:previous nesting
            case sourceNotFileURL(URL)
            case destinationNotFileURL(URL)
            case sourceAlreadyExists(URL)
            case destinationDoesNotExist(URL)
            case symlinkCreationFailed(source: URL, destination: URL, error: any Error)
        }
    }
}
