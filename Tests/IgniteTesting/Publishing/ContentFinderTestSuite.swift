//
// ContentFinderTestSuite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// MARK: ContentFinder Tst case initializers
enum ContentFinderSuite {
    typealias FIT = ContentFinderTests.FileItem
    typealias Tst = ContentFinderTests.Tst

    // setup directory root names
    private static let (normal, alt, err) = ("normal", "alt", "err")

    /// ``Tst`` test cases:
    /// - 0 (ok): normal files, no links (and basis for all other tests)
    /// - 1 (ok): link to file alt/d0 file
    /// - 2 (err): link to another directory in same root
    /// - 3 (err): link to a parent directory
    /// - 4 (ok): link to dir in alt (specify expected deploy path's)
    ///
    /// Tst specifications normally just require the root names and file-item's,
    /// and Tst derives the expected deploy-paths from the file-items,
    /// but linking directories requires specifying expected deploy path's.
    static let tests = allTests

    private static let allTests: [Tst] = [
        // Tst(id, [root-names], file-items{, deploy-paths})

        // Normal files (no links)
        Tst(0, [normal], items: Alt.allWithNorm),

        // link to file
        Tst(1, [normal], items: Norm.all + NormFileLinksToAlt.all),

        // Detect duplicates and cycles from misconfigured links
        Tst(2, [err], items: DupErr.all, expectError: DupErr.message),
        Tst(3, [err], items: ParentErr.all, expectError: ParentErr.message),

        // link to directory
        Tst(
            4,
            [normal, alt],
            items: Norm.all + NormDirLinksToAlt.all,
            // Dir links require explicit `expect:` deploy paths.
            expect: Norm.content + NormDirLinksToAlt.content
        )
    ]

    // swiftlint:disable identifier_name

    // MARK: file-item directory groups: normal, alternate, error (parent/dup)

    // We use 3 groups with distinct root dirs to test links (to avoid false
    // positive if a link target is in the same root dir as the link).

    // How to interpret the ``FileItem`` declarations like
    // `static let d_rNorm_da_de = FIT.dir("de", d_rNorm_da)`?
    //
    // Member names reflect their path, with `FileItem` type as a prefix.
    // - type: d/directory, f/file, l/link, r/root-directory
    // - Path segments use _ separator
    // - So `/normal/da/fa.md` gets the name `f_rNorm_da_faMd`
    // - Links specify the linking file TO the target/destination path:
    // -   l_{link-source}_TO_{link-destination}
    // - So `l_rErr_dir0_TO_d_rErr_dir1`
    // - would mean `err/dir0` is a symlink to `err/dir1`
    //
    // Normal names are alphabetic, while error and alternate are numeric,
    // so the deploy path indicates if the item was in the normal tree.
    //
    // The FIT (FileItem) factories generally take the name and the parent:
    // `FIT.dir("da", rNorm)` produces `{rNorm}/da/` directory.
    // The factories run in the order specified;
    // any parent dir has to be listed before any child dir/file,
    // and a link target has to be listed before any link.
    //
    // The FIT link factory will create the link file, but requires the target.
    // The `Tst` file-items must include the target item before the link item,
    // but must not include the item representing the link source file,
    // and only use it in the link to specify the source.

    // Normal group files     # deploy path
    // - normal/fa.md         # /fa
    // - normal/da/fbb.md     # /da/fbb
    // - normal/da/de/feee.md # /da/de/feee
    enum Norm {
        static let rNorm = FIT.root(normal)
        static let d_rNorm_da = FIT.dir("da", rNorm)
        static let d_rNorm_da_de = FIT.dir("de", d_rNorm_da)
        static let f_rNorm_faMd = FIT.file("fa.md", rNorm)
        static let f_rNorm_da_fbbMd = FIT.file("fbb.md", d_rNorm_da)
        static let f_rNorm_da_de_feeeMd = FIT.file("feee.md", d_rNorm_da_de)

        // `FileItem`s to set up before the test for the normal group
        static let all = [
            rNorm, d_rNorm_da, d_rNorm_da_de,  // dirs
            f_rNorm_faMd, f_rNorm_da_fbbMd, f_rNorm_da_de_feeeMd  // files
        ]
        // fyi, expected deploy paths (strip root prefix and file suffix)
        static let content = ["/fa", "/da/fbb", "/da/de/feee"]
    }

    // Alternate files      # deploy path
    // - alt/g1.md          # /g1
    // - alt/d0/g22.md      # /d0/g22
    // - alt/d0/d11/g333.md # /d0/d11/g333
    enum Alt {
        static let rAlt = FIT.root(alt)
        static let d_rAlt_dir0 = FIT.dir("d0", rAlt)
        static let d_rAlt_dir0_dir11 = FIT.dir("d11", d_rAlt_dir0)
        static let f_rAlt_g1Md = FIT.file("g1.md", rAlt)
        static let f_rAlt_dir0_g22Md = FIT.file("g22.md", d_rAlt_dir0)
        static let f_rAlt_dir0_dir11_g333Md = FIT.file(
            "g333.md",
            d_rAlt_dir0_dir11
        )
        // This is used for the entire alt directory tree
        static let all = d0Tree + [f_rAlt_g1Md]

        // alt/d0 is also a link target, so specify its content separately.
        // When d0 is linked, resulting deploy-path's should not include
        // file outside d0 (i.e., `f_rAlt_g1Md`: `alt/g1.md`)
        static let d0Tree = [
            rAlt, d_rAlt_dir0, d_rAlt_dir0_dir11,  //
            f_rAlt_dir0_g22Md, f_rAlt_dir0_dir11_g333Md
        ]
        // test setup requires both this and normal tree
        static let allWithNorm = all + Norm.all
    }

    // parent-error files:
    // d1/d22/l2dir1 links to d1, its own parent
    enum ParentErr {
        static let rErr = FIT.root(err)
        static let d_rErr_dir1 = FIT.dir("d1", rErr)
        static let d_rErr_dir1_dir22 = FIT.dir("d22", d_rErr_dir1)
        static let f_rErr_dir1_dir22_l2d1 = FIT.file("l2d1", d_rErr_dir1_dir22)
        static let l_rErr_dir1_dir22_l_TO_d1_TO_rErr_dir1 = FIT.link(
            source: f_rErr_dir1_dir22_l2d1,
            dest: d_rErr_dir1
        )
        static let all = [
            rErr, d_rErr_dir1, d_rErr_dir1_dir22,
            // Don't include link file itself (f_rErr_dir1_dir22_l2d1)
            // The link will create it.
            l_rErr_dir1_dir22_l_TO_d1_TO_rErr_dir1
        ]
        // Very minimal check of the content of the expected error message
        static let message = "directorySeen"
    }

    // duplicate-error files
    // d0/l2dir12 links to d1, but d1 already included via normal traversal
    enum DupErr {
        static let rErr = FIT.root(err)
        static let d_rErr_dir0 = FIT.dir("d0", rErr)
        static let d_rErr_dir1 = FIT.dir("d1", rErr)
        static let d_rErr_dir1_dir22 = FIT.dir("d22", d_rErr_dir1)
        static let f_rErr_dir0_l2 = FIT.file("l2dir12", d_rErr_dir0)
        static let l_rErr_dir0_l_TO_dir12rErr_dir1 = FIT.link(
            source: f_rErr_dir0_l2,
            dest: d_rErr_dir1
        )

        // link creates extra visit for a directory, causing error
        static let all = [
            rErr, d_rErr_dir0, d_rErr_dir1, d_rErr_dir1_dir22,  //
            // don't include link file (f_rErr_dir0_l2); link factory creates it
            l_rErr_dir0_l_TO_dir12rErr_dir1
        ]
        // expected error message
        static let message = "directorySeen"
    }

    // ok: normal link to file in alt/ (normal/la.md -> alt/d0/g22.md)
    // Expect normal deploy paths, plus one for the alt file.
    enum NormFileLinksToAlt {
        static let f_rNorm_la = FIT.file("la.md", Norm.rNorm)
        static let l_f_rNorm_la_TO_f_rAlt_dir0_g22Md = FIT.link(
            source: f_rNorm_la,
            dest: Alt.f_rAlt_dir0_g22Md
        )
        static let all = [l_f_rNorm_la_TO_f_rAlt_dir0_g22Md]
    }

    // ok: normal link to dir in alt/d0.
    // Expect normal deploy paths, plus files in the tree from alt/d0,
    // but nothing else from alt/
    enum NormDirLinksToAlt {
        static let linkNameToD0 = "ld-alt_d0"
        static let d_rNorm_ldAltD0 = FIT.file(linkNameToD0, Norm.rNorm)
        static let l_f_rNorm_la_TO_f_rAlt_dir0 = FIT.link(
            source: d_rNorm_ldAltD0,
            dest: Alt.d_rAlt_dir0
        )
        static let all = Alt.d0Tree + [l_f_rNorm_la_TO_f_rAlt_dir0]
        // d0 tree has d0/g22.md and d0/d11/g333.md
        // but d0 path is set by the link name
        static let content = [
            "/\(linkNameToD0)/g22",
            "/\(linkNameToD0)/d11/g333"
        ]
    }
    // swiftlint:enable identifier_name
}
