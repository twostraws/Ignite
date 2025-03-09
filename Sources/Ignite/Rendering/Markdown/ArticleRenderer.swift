//
// ArticleRenderer.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol defining the basic information we need to get good
/// article parsing. This is implemented by the default
/// MarkdownToHTML parser included with Ignite, but users
/// can override that default in their `Site` conformance to
/// get a custom parser if needed.
public protocol ArticleRenderer {
    /// The title of this document.
    var title: String { get }

    /// The description of this document, which is the first paragraph.
    var description: String { get }

    /// The body text of this file, which includes its title by default.
    var body: String { get }

    /// Whether to remove the article's title from its body. This only applies
    /// to the first heading.
    var removeTitleFromBody: Bool { get }

    /// Parses Markdown provided as a direct input string.
    /// - Parameters:
    ///   - markdown: The Markdown to parse.
    ///   - removeTitleFromBody: True if the first title should be removed
    ///   from the final `body` property.
    init(markdown: String, removeTitleFromBody: Bool) throws
}
