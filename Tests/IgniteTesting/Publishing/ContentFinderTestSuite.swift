//
// ContentFinderTestSuite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

enum ContentFinderSuite {
    typealias FIT = ContentFinderTests.FileItem
    typealias Tst = ContentFinderTests.Tst

    private static let (normal, alt, err) = ("normal", "alt", "err")

    static let tests = allTests
    private static let allTests: [Tst] = [
        // Tst(root-names, file-items{, deploy-paths})
        Tst(0, [normal], items: Alt.allWithNorm),  // no links
        Tst(1, [normal], items: Norm.all + NormFileLinksToAlt.all),  // file links

        // dup/cycle detection (using links)
        Tst(2, [err], items: DupErr.all, expectError: DupErr.message),
        Tst(3, [err], items: ParentErr.all, expectError: ParentErr.message),

        // Dir links require explicit expected deploy paths.
        // ContentFinder correctly finds `/link-name/filename` deploy paths,
        // but Tst expected paths fails to correct for dir links
        Tst(
            4,
            [normal, alt],
            items: Norm.all + NormDirLinksToAlt.all,
            expect: Norm.content + NormDirLinksToAlt.content
        )
    ]

    // swiftlint:disable identifier_name
    // normal names are alphabetic and start with `normal/`
    enum Norm {
        static let rNorm = FIT.root(normal)
        static let d_rNorm_da = FIT.dir("da", rNorm)
        static let d_rNorm_da_de = FIT.dir("de", d_rNorm_da)
        static let f_rNorm_faMd = FIT.file("fa.md", rNorm)
        static let f_rNorm_da_fbbMd = FIT.file("fbb.md", d_rNorm_da)
        static let f_rNorm_da_de_feeeMd = FIT.file("feee.md", d_rNorm_da_de)
        static let all = [
            rNorm, d_rNorm_da, d_rNorm_da_de,  // dirs
            f_rNorm_faMd, f_rNorm_da_fbbMd, f_rNorm_da_de_feeeMd  // files
        ]
        static let content = ["/fa", "/da/fbb", "/da/de/feee"]
    }

    // alternate names are numeric and start with `alt/`
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
        static let all = d0Tree + [f_rAlt_g1Md]
        static let d0Tree = [
            rAlt, d_rAlt_dir0, d_rAlt_dir0_dir11,  //
            f_rAlt_dir0_g22Md, f_rAlt_dir0_dir11_g333Md
        ]
        static let allWithNorm = all + Norm.all
    }

    // link to parent: d1/d22/l2dir1 -> d1
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
        static let message = "directorySeen"
    }
    // dup: d0/l2dir12 -> d1, but d1 already included
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

        // link creates another visit for a directory
        static let all = [
            rErr, d_rErr_dir0, d_rErr_dir1, d_rErr_dir1_dir22,  //
            // don't include f_rErr_dir0_l2; link creates it
            l_rErr_dir0_l_TO_dir12rErr_dir1
        ]
        static let message = "directorySeen"
    }
    // file links into alt/ from normal/
    enum NormFileLinksToAlt {
        static let f_rNorm_la = FIT.file("la.md", Norm.rNorm)
        static let l_f_rNorm_la_TO_f_rAlt_dir0_g22Md = FIT.link(
            source: f_rNorm_la,
            dest: Alt.f_rAlt_dir0_g22Md
        )
        static let all = [l_f_rNorm_la_TO_f_rAlt_dir0_g22Md]
    }

    // dir links into alt/ from normal/
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
