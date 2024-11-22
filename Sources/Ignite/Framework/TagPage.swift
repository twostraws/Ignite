//
// TagPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Tag pages show all articles on your site that match a specific tag,
/// or all articles period if `tag` is nil. You get to decide what is shown
/// on those pages by making a custom type that conforms to this protocol.
///
/// ```swift
/// struct TagLayout: TagPage {
///     var body: some HTML {
///         Article {
///             Heading(tag ?? "All Posts")
///             // Show articles matching the tag
///         }
///     }
/// }
/// ```
public protocol TagPage: ThemePage {
    /// The type of HTML content this page will generate
    associatedtype Body: HTML

    /// The main content of the page
    @HTMLBuilder var body: Body { get }
}

extension TagPage {
    /// The current tag during page generation.
    public var tag: String? {
        TagContext.current
    }

    public var content: [Content] {
        TagContext.content
    }
}
