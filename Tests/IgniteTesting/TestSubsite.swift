//
// TestSubsite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Ignite

/// An example site used in tests.
struct TestSubsite: Site {
    var name = "My Test Subsite"
    var titleSuffix = " - My Test Subsite"
    var url = URL(static: "https://www.example.com/subsite")

    var builtInIconsEnabled: BootstrapOptions = .localBootstrap

    var homePage = TestSubsitePage()
    var layout = EmptyLayout()
}

/// An example page used in tests.
struct TestSubsitePage: StaticPage {
    var title = "Subsite Home"

    var body: some HTML {
        Text("Example subsite text")
    }
}
