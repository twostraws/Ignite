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
    /// Run each ``TestCase`` defined in the ``ContentFinderTestCases`` using ``run(_:)``.
    ///
    /// Verify any error thrown is expected.
    @Test("Find Content", arguments: ContentFinderTestCases.tests)
    func findContent(test: TestCase) async throws {
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

    /// Run a test case:
    /// - Set up the directory tree specified by the test ``FileItem`` array
    /// - Run ``ContentFinder/find()``, looking for the suffixes.
    /// - If ok, compare with expected list of deploy paths
    /// - If error thrown, caller will compare with expected error text
    func run(_ test: TestCase) throws {
        if let inputError = test.inputError {
            throw inputError // configuration failure
        }
        guard let baseDirectory = try Self.makeSuiteBaseDirectory(test.id) else {
            #expect(Bool(false), "Unable to make suite base dir")
            return
        }
        defer { Self.removeSuiteBaseDirectory(baseDirectory) }

        // Configure directory tree
        let root = try test.setupRootPath(baseDirectory, id: test.id)

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
        guard expectPaths != foundPaths else { return } // <------ success

        // fail: report difference as markdown list of common, added, missing
        // Get label and array for each header/list
        let both = ("both", foundPaths.intersection(expectPaths))
        let extra = ("extra", foundPaths.subtracting(both.1))
        let missing = ("missing", expectPaths.subtracting(both.1))

        // Create each section, join them all, and prefix with test label
        let all = [extra, missing, both]
        let alls = all.map {
            MdHeaderList.h2SortQuiet.generateMarkdownSection(header: $0.0, items: Array($0.1))
        }
        let allsJoined = alls.joined(separator: "")
        let message = "\n# \(test.id)/\(test.directoryRoots)\(allsJoined)"

        enum EmitError: Error, CustomStringConvertible {
            case message(String)
            var description: String {
                switch self {
                case .message(let result): result
                }
            }
        }
        Issue.record(EmitError.message(message))
    }

    /// Make the temporary base directory of the test case, deleting any existing one.
    /// - Parameter index: Int id for test (if duplicate, parallel tests will conflict with each other)
    /// - Returns: file: URL to writable temporary directory, if successful.
    static func makeSuiteBaseDirectory(_ id: String) throws -> URL? {
        let name = "ContentFinder.find_\(id)"
        var foundUrl = try Files.makeTempDirectory(name: name)
        if !foundUrl.found {
            return foundUrl.url
        }
        try Files.delete(foundUrl.url)
        foundUrl = try Files.makeTempDirectory(name: name)
        return foundUrl.found ? nil : foundUrl.url
    }

    /// Delete the temporary base directory of the test case.
    ///
    /// This prints but otherwise ignores errors.
    static func removeSuiteBaseDirectory(_ baseDirectory: URL, caller: String = #function) {
        do {
            try Files.delete(baseDirectory)
        } catch {
            print("## \(caller) test cleanup error\n\(error)")
        }
    }

    /// Specify directory root, files/dirs, and links for ``Tst`` filesystem setup.
    indirect enum FileItem {
        case root(_ name: String)
        case file(_ name: String, _ parent: FileItem)
        case directory(_ name: String, _ parent: FileItem)
        /// Link from a non-existing source symlink to an existing item.
        case link(source: FileItem, dest: FileItem)
    }

    /// A ``ContentFinder`` test case specifies the filesystem items to set up the test
    /// and expected results from running
    /// ``ContentFinder.find(root:, suffixes:, contentMaker:)``
    /// (either a set of paths or some error text).
    struct TestCase: CustomStringConvertible {
        /// User-defined but unique value to keep parallel test temp directories distinct.
        let id: String = UUID().uuidString

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
        let directoryRoots: [String]

        /// Expected deploy paths from running find (possibly derived from ``items``)
        let expectDeployPaths: Set<String>

        /// True when ``expectPaths`` were not specified but calculated.
        let expectPathsWereDerived: Bool

        /// If specified, expect an error message containing this.
        let expectError: String?

        /// Save ``InputError`` at init-time to throw at run-time, for configuration errors.
        let inputError: InputError?

        /// Initialize with suffixes, file-items, and optional expected deploy paths.
        /// - Parameters:
        ///   - roots: An array directory root names in the test
        ///   - suffixes: An array of file suffixes to find
        ///   - items: An array of ``FileItem`` to set up before calling `findContent(test:)`
        ///   - expect: An optional array of deploy paths (derived if `nil`)
        ///   - expectError: An optional error message for content-error tests
        init(
            roots: [String],
            suffixes: [String] = [".md"],
            items: [FileItem],
            expect: [String]? = nil,
            expectError: String? = nil
        ) {
            if roots.isEmpty {
                inputError = .emptyRoots
            } else if let index = roots.firstIndex(where: { $0.isEmpty }) {
                inputError = .emptyRoot(index)
            } else if suffixes.isEmpty {
                inputError = .emptySuffixes
            } else if let index = suffixes.firstIndex(where: { $0.isEmpty }) {
                inputError = .emptySuffix(index)
            } else {
                inputError = nil
            }
            self.directoryRoots = roots
            self.suffixes = suffixes
            self.items = items
            self.expectError = expectError
            if let expect {
                expectDeployPaths = Set(expect)
                expectPathsWereDerived = false
            } else {
                expectPathsWereDerived = true
                expectDeployPaths = Set(
                    items.compactMap {
                        Self.expectDeployPath(
                            path: $0.path,
                            roots: roots,
                            suffixes: suffixes
                        )
                    }
                )
            }
        }

        /// Setup directory tree for test
        /// - Parameter suiteBaseDir: Parent directory for test directory
        /// - Returns: URL for test directory, populated per ``items`` ``FileItem``
        func setupRootPath(_ suiteBaseDir: URL, id: String) throws -> URL {
            // swiftlint:disable:next nesting
            typealias ItemURL = (item: FileItem, url: URL)
            // swiftlint:disable:next nesting
            enum SetupError: Error { // Better name than TargetError
                case itemAlreadyExists(_ url: URL, item: FileItem)
                case baseDirectoryAlreadyExists(URL)
                case duplicateSourceDirectory(path: String, next: URL, prior: URL)
                case noSourceDirectory(path: String, itemUrls: [ItemURL])
            }
            let testBaseDir = try makeTestBaseDirectory(suiteBaseDir, id: id)
            guard !testBaseDir.found else {
                throw SetupError.baseDirectoryAlreadyExists(testBaseDir.url)
            }
            let maker = FileItemMaker(baseDirectory: testBaseDir.url)
            let sourcePath = directoryRoots.first ?? "Never have no roots"
            var sourceDirectory: URL?
            var itemURLs = [ItemURL]()
            for item in items {
                let foundURL = try maker.make(item)
                if foundURL.found {
                    throw SetupError.itemAlreadyExists(foundURL.url, item: item)
                }
                itemURLs.append((item, foundURL.url))
                if sourcePath == item.path {
                    if let sourceDirectory {
                        throw SetupError.duplicateSourceDirectory(
                            path: sourcePath,
                            next: foundURL.url,
                            prior: sourceDirectory
                        )
                    }
                    sourceDirectory = foundURL.url
                }
            }
            guard let sourceDirectory else {
                throw SetupError.noSourceDirectory(path: sourcePath, itemUrls: itemURLs)
            }
            return sourceDirectory
        }

        func tearDown(testBaseDir: URL) throws {
            if Files.isReachable(testBaseDir) {
                try Files.delete(testBaseDir)
            }
        }

        /// Both test directory and suite directory use the test index to avoid conflict with other tests.
        private func makeTestBaseDirectory(
            _ suiteBaseDirectory: URL,
            id: String
        ) throws -> Files.FoundURL {
            let url = Files.makeDirectoryURL(suiteBaseDirectory, path: "Tst_\(id)")
            return try Files.makeDirectory(at: url)
        }

        var description: String {
            let root = directoryRoots.count == 1 ? directoryRoots.first! : "\(directoryRoots)"
            let prefix = "[\(id)] \(root)"
            let eol = " " // single-line (test label); use "\n" when debugging
            if let inErr = inputError {
                return "\(prefix) input error:\(eol)\(inErr)"
            }
            if let err = expectError {
                return "\(prefix) error: \(err)"
            }
            let sfx = suffixes == [".md"] ? "" : " suffixes: \(suffixes)"
            let exp = expectPathsWereDerived ? " expect(derived)" : "expect"
            let (pre, sep) = eol == " " ? (" ", ", ") : ("\n- ", "\n- ")
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
            return String(path[start ..< end])
        }

        /// ``TestCase`` configuration errors
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
