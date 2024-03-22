//
// Hint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PageElement {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A copy of the current element with the tooltip attached.
    public func hint(text: String) -> Self {
        self
            .data("bs-toggle", "tooltip")
            .data("bs-title", text)
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A copy of the current element with the tooltip attached.
    public func hint(html: String) -> Self {
        self
            .data("bs-toggle", "tooltip")
            .data("bs-title", html)
            .data("bs-html", "true")
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A copy of the current element with the tooltip attached.

    public func hint(markdown: String) -> Self {
        let parser = MarkdownToHTML(markdown: markdown)

        // Remove any <p></p> tags, because these will be
        // added automatically in render(). This allows us
        // to retain any styling applied elsewhere, e.g.
        // the `font()` modifier.
        let cleanedHTML = parser.body.replacing(#/<\/?p>/#, with: "")
        
        return self
            .data("bs-toggle", "tooltip")
            .data("bs-title", cleanedHTML)
            .data("bs-html", "true")
    }
}
