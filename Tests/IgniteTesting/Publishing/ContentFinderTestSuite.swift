//
// ContentFinderTestSuite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

enum ContentFinderTestCases {
    typealias FileItem = ContentFinderTests.FileItem
    typealias TestCase = ContentFinderTests.TestCase

    // Directory root names for different test scenarios
    private static let (source, target, error) = ("source", "target", "error")

    /// ``TestCase``:
    /// - 0 (ok): Base directory structure with no symlinks
    /// - 1 (ok): Create symlink from source file to target file
    /// - 2 (err): Detect duplicate directory traversal via symlink
    /// - 3 (err): Detect circular symlink to parent directory
    /// - 4 (ok): Create symlink from source directory to target directory
    ///
    /// Most test cases only need root names and file items.
    /// Directory symlink tests also require explicit deploy paths.
    static let tests: [TestCase] = [
        // Base directory structure
        TestCase(
            roots: [source],
            items: SymlinkTargetDirectory.allWithNorm
        ),

        // Create file symlink
        TestCase(
            roots: [source],
            items: SymlinkSourceDirectory.all + FileSymlinkCreation.all
        ),

        // Error cases
        TestCase(
            roots: [error],
            items: DuplicateSymlinkTraversalError.all,
            expectError: DuplicateSymlinkTraversalError.message
        ),

        TestCase(
            roots: [error],
            items: CircularSymlinkError.all,
            expectError: CircularSymlinkError.message
        ),

        // Create directory symlink
        TestCase(
            roots: [source, target],
            items: SymlinkSourceDirectory.all + DirectorySymlinkCreation.all,
            // Directory symlinks require explicit deploy paths
            expect: SymlinkSourceDirectory.content + DirectorySymlinkCreation.content
        )
    ]

    // We use separate source and target directories to avoid false positives
    // when testing symlinks. The source directory provides the base structure
    // for all working test cases.

    // How to interpret the ``FileItem`` declarations like
    // `static let d_rNorm_da_de = FileItem.directory("de", d_rNorm_da)`?
    //
    // Member names reflect their path, with `FileItem` type as a prefix:
    // - type: d/directory, f/file, l/link, r/root-directory
    // - Path segments use _ separator
    // - So `/source/da/fa.md` gets the name `f_rNorm_da_faMd`
    // - Symlinks specify the source TO the target/destination path:
    // -   l_{source}_TO_{destination}
    // - So `l_rErr_d0_TO_d_rErr_d1`
    // - would mean `err/d0` is a symlink to `err/d1`
    //
    // Source paths use alphabetic names while target/error paths use numeric names,
    // making it clear which tree an item belongs to.
    // Files often indicate depth via name duplication
    // (`/fa.md`, `d0/gbb.md`, `d0/d11/fccc.md`), but directories may not.
    //
    // The FileItem factories take the name and parent:
    // `FileItem.directory("da", rNorm)` produces directory `.../source/da/`.
    // Items must be created in order - parents before children,
    // symlink targets before symlinks.
    //
    // The symlink factory creates the link file but requires the target.
    // Include the target item before the symlink, but not the source file.
    // Only use the source file in the symlink to specify its location.

    // swiftlint:disable identifier_name

    // Source directory structure:
    // - source/fa.md         # /fa
    // - source/da/fbb.md     # /da/fbb
    // - source/da/de/feee.md # /da/de/feee
    private enum SymlinkSourceDirectory {
        static let rNorm = FileItem.root(source)
        static let d_rNorm_da = FileItem.directory("da", rNorm)
        static let d_rNorm_da_de = FileItem.directory("de", d_rNorm_da)
        static let f_rNorm_faMd = FileItem.file("fa.md", rNorm)
        static let f_rNorm_da_fbbMd = FileItem.file("fbb.md", d_rNorm_da)
        static let f_rNorm_da_de_feeeMd = FileItem.file("feee.md", d_rNorm_da_de)

        // FileItems to set up before the test
        static let all = [
            rNorm, d_rNorm_da, d_rNorm_da_de, // dirs
            f_rNorm_faMd, f_rNorm_da_fbbMd, f_rNorm_da_de_feeeMd // files
        ]
        // Expected deploy paths (strip root prefix and file suffix)
        static let content = ["/fa", "/da/fbb", "/da/de/feee"]
    }

    // Target directory structure:
    // - target/g1.md          # /g1
    // - target/d0/g22.md      # /d0/g22
    // - target/d0/d11/g333.md # /d0/d11/g333
    private enum SymlinkTargetDirectory {
        static let rAlt = FileItem.root(target)
        static let d_rAlt_d0 = FileItem.directory("d0", rAlt)
        static let d_rAlt_d0_dir11 = FileItem.directory("d11", d_rAlt_d0)
        static let f_rAlt_g1Md = FileItem.file("g1.md", rAlt)
        static let f_rAlt_d0_g22Md = FileItem.file("g22.md", d_rAlt_d0)
        static let f_rAlt_d0_dir11_g333Md = FileItem.file(
            "g333.md",
            d_rAlt_d0_dir11
        )
        // Complete target directory tree
        static let all = d0Tree + [f_rAlt_g1Md]

        // d0 subtree is used as a symlink target separately
        // When d0 is linked, resulting deploy paths exclude files outside d0
        // (i.e., exclude f_rAlt_g1Md: target/g1.md)
        static let d0Tree = [
            rAlt, d_rAlt_d0, d_rAlt_d0_dir11, //
            f_rAlt_d0_g22Md, f_rAlt_d0_dir11_g333Md
        ]
        // Test setup requires both target and source trees
        static let allWithNorm = all + SymlinkSourceDirectory.all
    }

    // Test circular symlink error:
    // Create symlink from d1/d22/l2dir1 to d1 (its own parent)
    private enum CircularSymlinkError {
        static let rErr = FileItem.root(error)
        static let d_rErr_d1 = FileItem.directory("d1", rErr)
        static let d_rErr_d1_d22 = FileItem.directory("d22", d_rErr_d1)
        static let f_rErr_d1_d22_l2d1 = FileItem.file("l2d1", d_rErr_d1_d22)
        static let l_rErr_d1_d22_l_TO_d1_TO_rErr_d1 = FileItem.link(
            source: f_rErr_d1_d22_l2d1,
            dest: d_rErr_d1
        )
        static let all = [
            rErr, d_rErr_d1, d_rErr_d1_d22,
            // Symlink factory creates the source file
            l_rErr_d1_d22_l_TO_d1_TO_rErr_d1
        ]
        // Expected error message
        static let message = "directorySeen"
    }

    // Test duplicate traversal error:
    // Create symlink from d0/l2dir12 to d1, where d1 was already visited
    private enum DuplicateSymlinkTraversalError {
        static let rErr = FileItem.root(error)
        static let d_rErr_d0 = FileItem.directory("d0", rErr)
        static let d_rErr_d1 = FileItem.directory("d1", rErr)
        static let d_rErr_d1_d22 = FileItem.directory("d22", d_rErr_d1)
        static let f_rErr_d0_l2 = FileItem.file("l2dir12", d_rErr_d0)
        static let l_rErr_d0_l_TO_d12rErr_d1 = FileItem.link(
            source: f_rErr_d0_l2,
            dest: d_rErr_d1
        )

        static let all = [
            rErr, d_rErr_d0, d_rErr_d1, d_rErr_d1_d22, //
            // Symlink factory creates the source file
            l_rErr_d0_l_TO_d12rErr_d1
        ]
        // Expected error message
        static let message = "directorySeen"
    }

    // Test creating symlink from source file to target file:
    // source/la.md -> target/d0/g22.md
    private enum FileSymlinkCreation {
        static let f_rNorm_la = FileItem.file("la.md", SymlinkSourceDirectory.rNorm)
        static let l_f_rNorm_la_TO_f_rAlt_d0_g22Md = FileItem.link(
            source: f_rNorm_la,
            dest: SymlinkTargetDirectory.f_rAlt_d0_g22Md
        )
        static let all = [l_f_rNorm_la_TO_f_rAlt_d0_g22Md]
    }

    // Test creating symlink from source directory to target directory:
    // Create symlink to target/d0 and verify correct deploy paths
    private enum DirectorySymlinkCreation {
        static let linkNameToD0 = "ld-alt_d0"
        static let d_rNorm_ldAltD0 = FileItem.file(linkNameToD0, SymlinkSourceDirectory.rNorm)
        static let l_f_rNorm_la_TO_f_rAlt_d0 = FileItem.link(
            source: d_rNorm_ldAltD0,
            dest: SymlinkTargetDirectory.d_rAlt_d0
        )
        static let all = SymlinkTargetDirectory.d0Tree + [l_f_rNorm_la_TO_f_rAlt_d0]
        // Expected deploy paths use the symlink name:
        // - /ld-alt_d0/g22
        // - /ld-alt_d0/d11/g333
        static let content = [
            "/\(linkNameToD0)/g22",
            "/\(linkNameToD0)/d11/g333"
        ]
    }
    // swiftlint:enable identifier_name
}
