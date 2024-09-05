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
    var url: URL = URL("https://www.yoursite.com/subsite")

    var themeColor: Color? = .firebrick
    var backgroundColor: Color? = .black
    var shortName: String? = "TestSite"
    var categories: [String]? = []
    var icons: [Icon]? = []
    
    var builtInIconsEnabled: BootstrapOptions = .localBootstrap
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
