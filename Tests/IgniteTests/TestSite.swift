//
// TestSite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// An example site used in tests.
struct TestSite: Site {
    
    
    var name = "My Test Site"
    var titleSuffix = " - My Test Site"
    var url: URL = URL("https://www.yoursite.com")

    var themeColor: Color? = .firebrick
    var backgroundColor: Color? = .black
    var shortName: String? = "TestSite"
    var categories: [String]? = []
    var icons: [Icon]? = []
    
    var builtInIconsEnabled: BootstrapOptions = .localBootstrap
    var syntaxHighlighters = [SyntaxHighlighter.objectiveC]

    var homePage = TestPage()
    var theme = EmptyTheme()
}

/// An example page  used in tests.
struct TestPage: StaticPage {
    var title = "Home"

    func body(context: PublishingContext) -> [any BlockElement] {
        Text("Example text")
    }
}
