//
// ContentFinderTestHelp.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

@testable import Ignite

extension ContentFinderTests {

    enum MdHeaderList {
        case head(level: Int, sort: Bool, skipEmpty: Bool)
        case h2Quiet
        case h2SortQuiet

        func md<T: StringProtocol>(
            _ header: T? = nil,
            _ list: [T]
        ) -> String {
            let (_, sort, skipEmpty) = lvlSrtSkp
            if list.isEmpty && skipEmpty { return "" }
            let (headPrefix, listPrefix) = prefixes(header, list.isEmpty)
            var out = ""
            if let headPrefix, let header {
                out += headPrefix
                out += header
            }
            guard let listPrefix, !list.isEmpty else { return out }
            out += listPrefix // initial
            let target = sort ? list.sorted() : list
            out += target.joined(separator: listPrefix)
            return out
        }
        // swiftlint:disable:next large_tuple
        private var lvlSrtSkp: (level: Int, sort: Bool, skipEmpty: Bool) {
            switch self {
            case let .head(level, sort, skip): (level, sort, skip)
            case .h2Quiet: (2, false, true)
            case .h2SortQuiet: (2, true, true)
            }
        }
        private func prefixes<T: StringProtocol>(
            _ header: T?,
            _ hasList: Bool
        ) -> (head: String?, list: String?) {
            let (level, _, skipEmpty) = lvlSrtSkp
            if skipEmpty && !hasList { return (nil, nil) }
            var head: String?
            if let header, !header.isEmpty {
                head = "\n\(String(repeating: "#", count: level)) "
            }
            return (head, hasList ? "\n- " : nil)
        }
    }
}
extension ContentFinderTests {
    struct FileItemMaker {
        let baseDir: URL
        @discardableResult
        func make(_ item: FileItem) throws -> Files.FoundURL {
            switch item {
            case .root(let name):
                let url = Files.makeUrlToDir(baseDir, path: name)
                return try Files.makeDir(url: url)
            case .file:
                let url = Files.makeUrlToFile(baseDir, path: item.path)
                return try Files.makeFile(file: url)
            case .dir:
                let url = Files.makeUrlToDir(baseDir, path: item.path)
                return try Files.makeDir(url: url)
            case let .link(source, dest):
                let src = Files.makeUrlToFile(baseDir, path: source.path)
                let dst = Files.makeUrlToFile(baseDir, path: dest.path)
                do {
                    try Files.createSymlink(source: src, dest: dst)
                } catch Files.SymlinkErr.symlinkError(let src, _, _) {
                    return (true, src)
                }
                return (false, src)
            }
        }
    }
}

extension ContentFinderTests.FileItem: CustomStringConvertible {
    var description: String {
        "\(label)(\(name)\(parent.map {" in: \($0.path)"} ?? ""))"
    }
}
extension ContentFinderTests.FileItem {
    var isFile: Bool { Self.fileN == index0 }
    static let (rootN, fileN, dirN, linkN) = (0, 1, 2, 3)
    static let labels = ["root", "file", "dir", "link"]
    private var index0: Int {
        switch self {
        case .root: Self.rootN
        case .file: Self.fileN
        case .dir: Self.dirN
        case .link: Self.linkN
        }
    }

    var name: String { nameParent.name }
    var parent: Self? { nameParent.parent }
    var nameParent: (name: String, parent: Self?) {
        switch self {
        case .root(let name): (name, nil)
        case let .file(name, parnt), let .dir(name, parnt): (name, parnt)
        case .link(let source, _): source.nameParent
        }
    }
    var label: String { Self.labels[index0] }

    func firstMatchingFileSuffix(_ suffixes: [String]) -> String? {
        guard
            isFile,
            let index = ContentFinder.suffixStart(
                name: nameParent.name,
                suffixes: suffixes)
        else {
            return nil
        }
        return String(nameParent.name[index...])
    }

    var path: String {
        switch self {
        case .root(let name): name
        case let .file(name, parent): "\(parent.path)/\(name)"
        case let .dir(name, parent): "\(parent.path)/\(name)"
        case let .link(source, _): source.path
        }
    }
}

extension ContentFinderTests {
    enum Files {
        // swiftlint:disable:next nesting
        typealias FoundURL = (found: Bool, url: URL)

        static func isReachable(_ url: URL, check: Bool = true) -> Bool {
            if let reachable = try? url.checkResourceIsReachable() {
                return reachable == check
            }
            return false
        }

        static func makeFile(file: URL) throws -> FoundURL {
            if isReachable(file) { return (true, file) }
            try "".write(to: file, atomically: true, encoding: .utf8)
            return (false, file)
        }

        static func makeDir(url: URL, clear: Bool = true) throws -> FoundURL {
            let mgr = FileManager.default
            var reachable = isReachable(url)
            if reachable {
                if clear {
                    try delete(url: url)
                    reachable = isReachable(url)
                }
                if reachable {
                    return (true, url)
                }
            }
            try mgr.createDirectory(at: url, withIntermediateDirectories: false)
            return (false, url)
        }

        static func makeUrlToDir(_ baseDir: URL, path: String) -> URL {
            makeURL(baseDir, path, isFile: false)
        }

        static func makeUrlToFile(_ baseDir: URL, path: String) -> URL {
            makeURL(baseDir, path, isFile: true)
        }

        private static func makeURL(
            _ dir: URL,
            _ path: String,
            isFile: Bool
        ) -> URL {
            dir.appending(
                components: path,
                directoryHint: isFile ? .isDirectory : .notDirectory
            )
        }

        static func delete(url: URL) throws {
            try FileManager.default.removeItem(at: url)
        }

        static func makeTempDir(
            name: String
        ) throws -> FoundURL {
            let mgr = FileManager.default
            let url = mgr.temporaryDirectory.appending(
                component: name,
                directoryHint: .isDirectory
            )
            return try makeDir(url: url)
        }
        static func createSymlink(source: URL, dest: URL) throws {
            // swiftlint:disable:next nesting
            typealias Err = SymlinkErr
            if !source.isFileURL {
                throw Err.sourceNotFileScheme(source)
            }
            if !dest.isFileURL {
                throw Err.destNotFileScheme(dest)
            }
            if isReachable(dest, check: false) {
                throw Err.destNotReachable(dest)
            }
            if isReachable(source) {
                throw Err.sourceExists(source)
            }
            do {
                let mgr = FileManager.default
                try mgr.createSymbolicLink(at: source, withDestinationURL: dest)
            } catch {
                throw Err.symlinkError(source: source, dest: dest, error: error)
            }
        }
        // swiftlint:disable:next nesting
        enum SymlinkErr: Error {
            case sourceNotFileScheme(URL), destNotFileScheme(URL)
            case sourceExists(URL), destNotReachable(URL)
            case symlinkError(source: URL, dest: URL, error: any Error)
        }
    }
}
