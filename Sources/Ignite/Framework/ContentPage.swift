//
// ContentPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Content pages describe custom page structures for articles. You can provide
/// one layout in your site to use that for all articles, or create custom layouts and
/// assign them uniquely to individual articles.
///
/// ```swift
/// struct MyArticle: ContentPage {
///
///     var body: some HTML {
///         Heading(content.title)
///         Text(content.description)
///     }
/// }
/// ```
public protocol ContentPage: ThemePage {
    /// The type of HTML content this page will generate
    associatedtype Body: HTML

    /// The main content of the page
    @HTMLBuilder var body: Body { get }
}

public extension ContentPage {
    /// The current Markdown content being rendered.
    var content: Content {
        ContentContext.current
    }
}
