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
/// To access the current article's content within your page layout, use the `@Content` property wrapper:
/// ```swift
/// struct MyArticle: ContentPage {
///     @Content private var article
///
///     var body: some HTML {
///         Heading(article.title)
///         Text(article.description)
///     }
/// }
/// ```
public protocol ContentPage: ThemePage {
    /// The type of HTML content this page will generate
    associatedtype Body: HTML
    
    /// The main content of the page, built using the HTML DSL
    @HTMLBuilder var body: Body { get }
}
