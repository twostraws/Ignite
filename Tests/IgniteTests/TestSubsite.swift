//
// TestSubsite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// An example site used in tests.
struct TestSubsite: Site {
    var name = "My Test Subsite"
    var titleSuffix = " - My Test Subsite"
    var url = URL(static: "https://www.yoursite.com/subsite")

    var builtInIconsEnabled: BootstrapOptions = .localBootstrap
    var syntaxHighlighters = [SyntaxHighlighter.objectiveC]

    var homePage = TestSubsitePage()
    var theme = EmptyTheme()
}

/// An example page  used in tests.
struct TestSubsitePage: StaticPage {
    var title = "Subsite Home"

    var body: some HTML {
        Text("Example subsite text")
    }
}
