//
// ContentFinderTestHelp.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension [String] {
    func mdLine(
        head: String? = nil,
        hn: Int = 2,
        ul: String = "\n- ",
        sort: Bool = false,
        skipHeadIfEmpty: Bool = true
    ) -> String {
        if isEmpty && skipHeadIfEmpty { return "" }
        var out = ""
        if let head, !head.isEmpty {
            let h = hn < 1 ? 1 : hn > 6 ? 6 : hn
            out += "\n"
            out += String(repeating: "#", count: h)
            out += " "
            out += head
        }
        if isEmpty { return out }
        out += ul
        let target = sort ? sorted() : self
        out += target.joined(separator: ul)
        return out
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
                let d = Files.makeUrlToFile(baseDir, path: dest.path)
                do {
                    try Files.createSymlink(source: src, dest: d)
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
        "\(label)(\(name)\(parent.map{" in: \($0.path)"} ?? ""))"
    }
}
extension ContentFinderTests.FileItem {
    var isFile: Bool { Self.fn == index0 }
    static let (rn, fn, dn, ln) = (0, 1, 2, 3)
    static let labels = ["root", "file", "dir", "link"]
    private var index0: Int {
        switch self {
        case .root: Self.rn
        case .file: Self.fn
        case .dir: Self.dn
        case .link: Self.ln
        }
    }

    var name: String { nameParent.name }
    var parent: Self? { nameParent.parent }
    var nameParent: (name: String, parent: Self?) {
        switch self {
        case .root(let n): (n, nil)
        case let .file(n, p), let .dir(n, p): (n, p)
        case .link(let source, _): source.nameParent
        }
    }
    var label: String { Self.labels[index0] }

    func firstMatchingFileSuffix(_ suffixes: [String]) -> String? {
        !isFile ? nil : suffixes.first { hasFileSuffix($0) }
    }
    func hasFileSuffix(_ suffix: String) -> Bool {
        isFile && nameParent.name.hasSuffix(suffix)
        // TODO add case-insensitive check
    }
    var path: String {
        switch self {
        case .root(let n): n
        case let .file(n, p), let .dir(n, p): "\(p.path)/\(n)"
        case let .link(source, _): source.path
        }
    }
}

extension ContentFinderTests {
    enum Files {
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
        enum SymlinkErr: Error {
            case sourceNotFileScheme(URL), destNotFileScheme(URL)
            case sourceExists(URL), destNotReachable(URL)
            case symlinkError(source: URL, dest: URL, error: any Error)
        }
    }
}
