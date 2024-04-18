//
// PublishingContextKey.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

struct PublishingContextKey: EnvironmentKey {
    static let defaultValue = PublishingContext.empty
}

extension EnvironmentValues {
    public var context: PublishingContext {
        get { self[PublishingContextKey.self] }
        set { self[PublishingContextKey.self] = newValue }
    }
}

extension  PublishingContext {
    struct EmptySite: Site {
        var name = ""
        var titleSuffix = ""
        var url = URL("http://example.com")

        var builtInIconsEnabled = false
        var syntaxHighlighters: [SyntaxHighlighter] = []

        var homePage = EmptyPage()
        var theme = EmptyTheme()
    }

    struct EmptyPage: StaticPage {
        var title: String = ""

        func body(context: PublishingContext) -> [any BlockElement] {
            Text("")
        }
    }

    fileprivate static var empty = try! PublishingContext(for: EmptySite(), from: "")
}
