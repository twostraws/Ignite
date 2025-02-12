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

    /// Run each ``Tst`` defined in the ``ContentFinderSuite`` using ``run(_:)``.
    ///
    /// Verify any error thrown is expected.
    @Test("find", arguments: ContentFinderSuite.tests)
    func find(test: Tst) async throws {
        do {
            try run(test)
            if let expectError = test.expectError, !expectError.isEmpty {
                #expect(Bool(false), "Expected error: \(expectError)")
            }
        } catch {
            if let exp = test.expectError {
                let message = "\(error)"
                #expect(message.contains(exp))
            } else {
                #expect(Bool(false), "\(error)")
            }
        }
    }

    /// Run a test case declared in ``Tst``:
    /// - Set up the directory tree specified by the test ``FileItem`` array
    /// - Run ``ContentFinder/find()``, looking for the ``Tst`` suffixes.
    /// - If ok, compare with expected list of deploy paths specified in ``Tst``
    /// - If error thrown, caller will compare with expected error text
    func run(_ test: Tst) throws {
        if let inputError = test.inputError {
            throw inputError // configuration failure
        }
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

        // fail: report difference as markdown list of common, added, missing
        // Get label and array for each header/list
        let both = ("both", foundPaths.intersection(expectPaths))
        let extra = ("extra", foundPaths.subtracting(both.1))
        let missing = ("missing", expectPaths.subtracting(both.1))

        // Create each section, join them all, and prefix with test label
        let all = [extra, missing, both]
        let alls = all.map { MdHeaderList.h2SortQuiet.md($0.0, Array($0.1)) }
        let allsJoined = alls.joined(separator: "")
        let message = "\n# \(test.index)/\(test.makeRoots)\(allsJoined)"

        // Emit error
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

    /// Make the temporary base directory of the test case, deleting any existing one.
    /// - Parameter index: Int id for test (if duplicate, parallel tests will conflict with each other)
    /// - Returns: file: URL to writable temporary directory, if successful.
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

    /// Delete the temporary base directory of the test case.
    ///
    /// This prints but otherwise ignores errors.
    static func removeSuiteBaseDir(_ baseDir: URL, caller: String = #function) {
        do {
            try Files.delete(url: baseDir)
        } catch {
            print("## \(caller) test cleanup error\n\(error)")
        }
    }

    /// Specify directory root, files/dirs, and links for ``Tst`` filesystem setup.
    indirect enum FileItem {
        case root(_ name: String)
        case file(_ name: String, _ parent: FileItem)
        case dir(_ name: String, _ parent: FileItem)
        /// Link from a non-existing source symlink to an existing item.
        case link(source: FileItem, dest: FileItem)
    }

    /// A ``ContentFinder`` test case specifies the filesystem items to set up the test
    /// and expected results from running
    /// ``ContentFinder.find(root:, suffixes:, contentMaker:)``
    /// (either a set of paths or some error text).
    struct Tst: CustomStringConvertible {
        /// User-defined but unique value to keep parallel test temp directories distinct.
        let index: Int

        /// ``ContentFinder.find(root:, suffixes:, contentMaker:)``
        /// parameter for file suffixes
        let suffixes: [String]

        /// ``FileItem``'s to set up before running `find`.
        /// Items are created in order specified (not recursing into parents)
        /// so the user must ensure parents are specified before children
        /// and link destinations are specified before links.
        let items: [FileItem]

        /// Names of directory roots configured in test.
        /// If the expected deploy paths are not specified explicitly,
        /// derive them by using the first name as the prefix to remove from the file-item's.
        let makeRoots: [String]

        /// Expected deploy paths from running find (possibly derived from ``items``)
        let expectDeployPaths: Set<String>

        /// True when ``expectPaths`` were not specified but calculated.
        let expectPathsWereDerived: Bool

        /// If specified, expect an error message containing this.
        let expectError: String?

        /// Save ``InputError`` at init-time to throw at run-time, for configuration errors.
        let inputError: InputError?

        /// Initialize ``Tst`` with suffixes, file-items, and optional expected deploy paths.
        /// - Parameters:
        ///   - index: Unique Int for distinguishing parallel tests
        ///   - makeRoots: Array of String names of directory roots in test
        ///   - suffixes: Array of String file suffixes to pass to find
        ///   - items: Array of ``FileItem`` to set up before calling find
        ///   - expect: Optional Array of String deploy paths (derived if nil)
        ///   - expectError: Optional String for content of error-throwing tests
        init(
            _ index: Int,
            _ makeRoots: [String],
            suffixes: [String] = [".md"],
            items: [FileItem],
            expect: [String]? = nil,
            expectError: String? = nil
        ) {
            if makeRoots.isEmpty {
                inputError = .emptyRoots
            } else if let index = makeRoots.firstIndex(where: { $0.isEmpty }) {
                inputError = .emptyRoot(index)
            } else if suffixes.isEmpty {
                inputError = .emptySuffixes
            } else if let index = suffixes.firstIndex(where: { $0.isEmpty }) {
                inputError = .emptySuffix(index)
            } else {
                inputError = nil
            }
            self.index = index
            self.makeRoots = makeRoots
            self.suffixes = suffixes
            self.items = items
            self.expectError = expectError
            if let expect {
                self.expectDeployPaths = Set(expect)
                expectPathsWereDerived = false
            } else {
                expectPathsWereDerived = true
                self.expectDeployPaths = Set(
                    items.compactMap {
                        Self.expectDeployPath(
                            path: $0.path,
                            roots: makeRoots,
                            suffixes: suffixes
                        )
                    }
                )
            }
        }

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

        /// Both test base-dir and suite base-dir used the test index to avoid conflict with other tests.
        private func makeTestBaseDir(
            _ suiteBaseDir: URL,
            index: Int
        ) throws -> Files.FoundURL {
            let url = Files.makeUrlToDir(suiteBaseDir, path: "Tst_\(index)")
            return try Files.makeDir(url: url)
        }

        var description: String {
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
            let eps = Array(expectDeployPaths).sorted().joined(separator: sep)
            return "\(prefix) \(sfx)\(exp)\(pre)\(eps)"
        }

        /// Expected deploy path removes the root prefix
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

        /// ``Tst`` configuration errors
        enum InputError: Error {
            // swiftlint:disable:previous nesting
            case emptyRoots
            case emptyRoot(Int)
            case emptySuffixes
            case emptySuffix(Int)
            case emptyExpect(Int)
        }
    }
}
