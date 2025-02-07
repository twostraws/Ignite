//
// ContentLayout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
public protocol Article: PageContent {}

public extension Article {
    /// The current Markdown content being rendered.
    var content: Content {
        EnvironmentStore.current.articleContent
    }
}
