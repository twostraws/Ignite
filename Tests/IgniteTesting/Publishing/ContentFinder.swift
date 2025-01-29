//
// ContentFinder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//
import Foundation
import Testing

@testable import Ignite

/// Tests for the `ContentFinder` type.
@Suite("ContentFinder")
actor ContentFinderTests {

    @Test("find", arguments: ContentFinderSuite.tests)
    func find(test: Tst) async throws {
        do {
            try run(test)
        } catch {
            if let exp = test.expectError {
                let message = "\(error)"
                #expect(message.contains(exp))
            } else {
                #expect(Bool(false), "\(error)")
            }
        }
    }

    func run(_ test: Tst) throws {
        guard let baseDir = try Self.makeSuiteBaseDir(test.index) else {
            #expect(Bool(false), "Unable to make suite base dir")
            return
        }
        defer { Self.removeSuiteBaseDir(baseDir) }

        // Configure directory tree
        let root = try test.setupRootPath(baseDir, index: test.index)
        // defer { try? test.tearDown(baseDir: root) }  // deleted baseDir above

        // Visit directory tree
        var found = [ContentFinder.DeployContent]()
        try ContentFinder.shared.find(root: root, suffixes: test.suffixes) {
            found.append($0)
            return true
        }
        // check paths found
        let expectPaths = test.expectDeployPaths
        let foundPaths = Set(found.map { "\($0.path)" })
        // poor output formatting
        // #expect(expectPaths == foundPaths)
        guard expectPaths != foundPaths else { return }  // <------ success

        // fail: report difference
        let both = ("both", foundPaths.intersection(expectPaths))
        let extra = ("extra", foundPaths.subtracting(both.1))
        let missing = ("missing", expectPaths.subtracting(both.1))
        let all = [extra, missing, both]
        let emit = MdHeaderList.h2SortQuiet
        let alls = all.map { emit.md($0.0, Array($0.1)) }
        let allsJoined = alls.joined(separator: "")
        let message = "\n# \(test.index)/\(test.makeRoots)\(allsJoined)"
        enum Err: Error, CustomStringConvertible {
            case message(String)
            var description: String {
                switch self {
                case .message(let result): result
                }
            }
        }
        Issue.record(Err.message(message))
    }

    static func makeSuiteBaseDir(_ index: Int) throws -> URL? {
        let name = "ContentFinder.find_\(index)"
        var foundUrl = try Files.makeTempDir(name: name)
        if !foundUrl.found {
            return foundUrl.url
        }
        try Files.delete(url: foundUrl.url)
        foundUrl = try Files.makeTempDir(name: name)
        return foundUrl.found ? nil : foundUrl.url
    }

    static func removeSuiteBaseDir(_ baseDir: URL, caller: String = #function) {
        do {
            try Files.delete(url: baseDir)
        } catch {
            print("## \(caller) test cleanup error\n\(error)")
        }
    }

    indirect enum FileItem {
        case root(_ name: String)
        case file(_ name: String, _ parent: FileItem)
        case dir(_ name: String, _ parent: FileItem)
        case link(source: FileItem, dest: FileItem)
    }

    struct Tst: CustomStringConvertible {
        let index: Int
        let suffixes: [String]
        let items: [FileItem]
        let makeRoots: [String]
        let expectPaths: Set<String>
        let expectPathsWereDerived: Bool
        let expectError: String?  // urk: very weak check for errors
        let inputError: InputError?
        init(
            _ index: Int,
            _ makeRoots: [String],
            suffixes: [String] = [".md"],
            items: [FileItem],
            expect: [String]? = nil,
            expectError: String? = nil
        ) {
            var err: InputError?
            if makeRoots.isEmpty {
                err = .emptyRoots
            } else if let index = makeRoots.firstIndex(where: { $0.isEmpty }) {
                err = .emptyRoot(index)
            } else if suffixes.isEmpty {
                err = .emptySuffixes
            } else if let index = suffixes.firstIndex(where: { $0.isEmpty }) {
                err = .emptySuffix(index)
            }
            self.index = index
            self.makeRoots = makeRoots
            self.suffixes = suffixes
            self.items = items
            self.expectError = expectError
            if let expect {
                self.expectPaths = Set(expect)
                expectPathsWereDerived = false
            } else {
                expectPathsWereDerived = true
                self.expectPaths = Set(
                    items.compactMap {
                        Self.expectDeployPath(
                            path: $0.path,
                            roots: makeRoots,
                            suffixes: suffixes
                        )
                    }
                )
            }
            self.inputError = err
        }

        var expectDeployPaths: Set<String> { expectPaths }

        /// Setup directory tree for test
        /// - Parameter suiteBaseDir: Parent directory for test directory
        /// - Returns: URL for test directory, populated per ``items`` ``FileItem``
        func setupRootPath(_ suiteBaseDir: URL, index: Int) throws -> URL {
            // swiftlint:disable:next nesting
            typealias ItemURL = (item: FileItem, url: URL)
            // swiftlint:disable:next nesting
            enum Err: Error {
                case foundTarget(_ url: URL, item: FileItem)
                case foundTestBaseDir(URL)
                case duplicateTargetFindDir(path: String, next: URL, prior: URL)
                case noTargetFindDir(path: String,
                    itemUrls: [ItemURL])
            }
            let testBaseDir = try makeTestBaseDir(suiteBaseDir, index: index)
            guard !testBaseDir.found else {
                throw Err.foundTestBaseDir(testBaseDir.url)
            }
            let maker = FileItemMaker(baseDir: testBaseDir.url)
            let targetPath = makeRoots.first ?? "Never have no roots"
            var targetFindDir: URL?
            var itemUrls = [ItemURL]()
            for item in items {
                let foundUrl = try maker.make(item)
                if foundUrl.found {
                    throw Err.foundTarget(foundUrl.url, item: item)
                }
                itemUrls.append((item, foundUrl.url))
                if targetPath == item.path {
                    if let targetFindDir {
                        throw Err.duplicateTargetFindDir(
                            path: targetPath,
                            next: foundUrl.url,
                            prior: targetFindDir
                        )
                    }
                    targetFindDir = foundUrl.url
                }
            }
            guard let targetFindDir else {
                throw Err.noTargetFindDir(path: targetPath, itemUrls: itemUrls)
            }
            return targetFindDir
        }

        func tearDown(testBaseDir: URL) throws {
            if Files.isReachable(testBaseDir) {
                try Files.delete(url: testBaseDir)
            }
        }

        private func makeTestBaseDir(
            _ suiteBaseDir: URL,
            index: Int
        ) throws -> Files.FoundURL {
            let url = Files.makeUrlToDir(suiteBaseDir, path: "Tst_\(index)")
            return try Files.makeDir(url: url)
        }

        var description: String {  // terrible labels
            let root = 1 == makeRoots.count ? makeRoots.first! : "\(makeRoots)"
            let prefix = "[\(index)] \(root)"
            let eol = " " // single-line (test label); use "\n" when debugging
            if let inErr = inputError {
                return "\(prefix) input error:\(eol)\(inErr)"
            }
            if let err = expectError {
                return "\(prefix) error: \(err)"
            }
            let sfx = suffixes == [".md"] ? "" : " suffixes: \(suffixes)"
            let exp = expectPathsWereDerived ? " expect(derived)" : "expect"
            let (pre, sep) = " " == eol ? (" ", ", ") : ("\n- ", "\n- ")
            let eps = Array(expectPaths).sorted().joined(separator: sep)
            return "\(prefix) \(sfx)\(exp)\(pre)\(eps)"
        }

        /// Expected deploy path removes the ``findRootPath`` prefix
        /// and the first-found suffix from ``suffixes``
        /// - Parameter path: String full deploy path
        /// - Returns: path without prefix or suffix, or nil if prefix or suffix not found
        static func expectDeployPath(
            path: String,
            roots: [String],
            suffixes: [String]
        ) -> String? {
            let prefix = roots.first(where: { path.hasPrefix($0) })
            guard let prefix else { return nil }
            let start = path.index(path.startIndex, offsetBy: prefix.count)
            let end = ContentFinder.suffixStart(name: path, suffixes: suffixes)
            guard let end, end > start else {
                return nil
            }
            return String(path[start..<end])
        }

        // swiftlint:disable:next nesting
        enum InputError: Error {
            case emptyRoots
            case emptyRoot(Int)
            case emptySuffixes
            case emptySuffix(Int)
            case emptyExpect(Int)
        }
    }
}
