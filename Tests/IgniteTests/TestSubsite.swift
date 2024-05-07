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
    var url = URL("https://www.yoursite.com/subsite")

    var builtInIconsEnabled = true
    var syntaxHighlighters = [SyntaxHighlighter.objectiveC]

    var homePage = TestSubsitePage()
    var theme = EmptyTheme()
}

/// An example page  used in tests.
struct TestSubsitePage: StaticPage {
    var title = "Subsite Home"

    func body(context: PublishingContext) -> [any BlockElement] {
        Text("Example subsite text")
    }
}
