//
// ContentLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Article pages describe custom page structures for articles. You can provide
/// one page in your site to use that for all articles, or create custom pages and
/// assign them uniquely to individual articles.
///
/// ```swift
/// struct MyArticle: ArticlePage {
///
///     var body: some HTML {
///         Heading(content.title)
///         Text(content.description)
///     }
/// }
/// ```
@MainActor
public protocol ArticlePage: LayoutContent {}

public extension ArticlePage {
    /// The current Markdown content being rendered.
    var article: Article {
        PublishingContext.shared.environment.article
    }
}
