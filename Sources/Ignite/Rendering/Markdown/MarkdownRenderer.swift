//
// MarkdownRenderer.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol defining the basic information we need to get good
/// Markdown parsing. This is implemented by the default
/// MarkdownToHTML parser included with Ignite, but users
/// can override that default in their `Site` conformance to
/// get a custom parser if needed.
public protocol MarkdownRenderer {
    /// The title of this document.
    var title: String { get }

    /// The description of this document, which is the first paragraph.
    var description: String { get }

    /// The body text of this file, which includes its title by default.
    var body: String { get }

    /// Whether to remove the Markdown title from its body. This only applies
    /// to the first heading.
    var removeTitleFromBody: Bool { get }

    /// A dictionary of metadata specified at the top of the file as YAML front matter.
    /// See https://jekyllrb.com/docs/front-matter/ for information.
    var metadata: [String: String] { get }

    /// Parses Markdown provided as a direct input string.
    /// - Parameters:
    ///   - markdown: The Markdown to parse.
    ///   - removeTitleFromBody: True if the first title should be removed
    ///   from the final `body` property.
    init(markdown: String, removeTitleFromBody: Bool) throws

    /// Parses Markdown provided from a filesystem URL.
    /// - Parameters:
    ///   - url: The filesystem URL to load.
    ///   - removeTitleFromBody: True if the first title should be removed
    ///   from the final `body` property.
    init(url: URL, removeTitleFromBody: Bool) throws
}
