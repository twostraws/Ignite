//
// SearchResult.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A template for displaying individual search results.
@MainActor
public struct SearchResult: Sendable {
    /// The title of the search result.
    public var title: some Element = Text("").class("result-title")

    /// The clickable link for the search result.
    public var link: some InlineElement = Link("", target: "").class("result-link")

    /// A brief description or excerpt of the search result content.
    public var description: some Element = Text("").class("result-description")

    /// The publication date of the content.
    public var date: (some Element)? = Text("").class("result-date")

    /// Optional tags associated with the search result.
    public var tags: (some Element)? = Text("").class("result-tags")
}
