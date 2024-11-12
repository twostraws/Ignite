//
// Content.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A property wrapper that provides access to the current Markdown content being rendered.
///
/// Use the `@Content` property wrapper in your layouts to access the current content:
/// ```swift
/// struct ArticleLayout: Layout {
///     @Content private var content
///
///     var body: some HTML {
///         Article {
///             Heading(content.title)
///             Text(content.description)
///             Markdown(content.body)
///         }
///     }
/// }
/// ```
/// > Important: This property wrapper is only valid during content page rendering.
/// The content context is managed automatically by the publishing system.
@MainActor
@propertyWrapper
public struct Content {
    public var wrappedValue: MarkdownContent {
        ContentContext.current
    }

    public init() {}
}
