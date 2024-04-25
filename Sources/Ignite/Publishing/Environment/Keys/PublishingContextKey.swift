//
// PublishingContextKey.swift
// Ignite
// https://www.github.com/piotrekjeremicz/Ignite
// See LICENSE for license information.
//

import Foundation

/// A key for accessing the `PublishingContext` value.
struct PublishingContextKey: EnvironmentKey {
    /// The default value for `PublishingContext` it is `.empty` representation of itself.
    static let defaultValue = PublishingContext.empty
}

/// Association of the custom key with its value.
extension EnvironmentValues {
    /// The `PublishingContext` environment value associated with a `PublishingContextKey`.
    public var context: PublishingContext {
        get { self[PublishingContextKey.self] }
        set { self[PublishingContextKey.self] = newValue }
    }
}

/// **This is temporary solution**
/// `PublishingContext` needs an empty representation of itself. It is provided by creating `EmptySite` structure.
/// Those structures should not be used anywhere else.
fileprivate extension  PublishingContext {
    struct EmptySite: Site {
        var name = ""
        var titleSuffix = ""
        var url = URL("https://example.com")

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

    static var empty = try! PublishingContext(for: EmptySite(), rootURL: URL.documentsDirectory)
}
