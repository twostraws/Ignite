//
// ContentPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Content layouts describe custom layout structures for articles. You can provide
/// one layout in your site to use that for all articles, or create custom layouts and
/// assign them uniquely to individual articles.
///
/// ```swift
/// struct MyArticle: ContentLayout {
///
///     var body: some HTML {
///         Heading(content.title)
///         Text(content.description)
///     }
/// }
/// ```
@MainActor
public protocol ContentLayout: EnvironmentReader {
    /// The type of HTML content this layout will generate
    associatedtype Body: HTML

    /// The main content of the layout
    @HTMLBuilder var body: Body { get }
}

public extension ContentLayout {
    /// The current Markdown content being rendered.
    var content: Content {
        ContentContext.current
    }
}
