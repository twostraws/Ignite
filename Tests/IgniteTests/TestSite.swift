//
// TestSite.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// An example site used in tests.
struct TestSite<HomePageType>: Site where HomePageType: StaticPage {
    var name = "My Test Site"
    var titleSuffix = " - My Test Site"
    var url = URL("https://www.yoursite.com")

    var builtInIconsEnabled = true
    var syntaxHighlighters = [SyntaxHighlighter.objectiveC]

    var theme = EmptyTheme()
    var homePage: HomePageType
    
    init(homePage: HomePageType) {
        self.homePage = homePage
    }
}

/// An example page  used in tests.
struct TestPage: StaticPage {
    var title = "Home"

    func body(context: PublishingContext) -> [any BlockElement] {
        Text("Example text")
    }
}

/// An example page with `@Environment` context used in tests.
struct EnvironmentTestPage: StaticPage {
    var title: String = "Environment Test"
    @Environment(\.context) private var environmentContext

    func body(context: PublishingContext) -> [any BlockElement] {
        Text(environmentContext.site.name)
    }
}
