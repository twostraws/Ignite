//
// Hint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds tooltips to HTML elements
struct HintModifier: HTMLModifier {
    /// The tooltip text to display
    private let text: String

    /// Whether the tooltip contains HTML
    private let isHTML: Bool

    /// Creates a new hint modifier with plain text
    /// - Parameter text: The text to show in the tooltip
    init(text: String) {
        self.text = text
        self.isHTML = false
    }

    /// Creates a new hint modifier with HTML content
    /// - Parameter html: The HTML to show in the tooltip
    init(html: String) {
        self.text = html
        self.isHTML = true
    }

    /// Creates a new hint modifier with Markdown content
    /// - Parameter markdown: The Markdown text to parse
    init(markdown: String) {
        let parser = MarkdownToHTML(markdown: markdown, removeTitleFromBody: true)
        // Remove any <p></p> tags to retain styling
        self.text = parser.body.replacing(#/<\/?p>/#, with: "")
        self.isHTML = true
    }

    /// Applies tooltip attributes to the provided HTML content
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with tooltip applied
    func body(content: some HTML) -> any HTML {
        content
            .data("bs-toggle", "tooltip")
            .data("bs-title", text)

        if isHTML {
            content.data("bs-html", "true")
        }

        return content
    }
}

public extension HTML {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some HTML {
        modifier(HintModifier(text: text))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some HTML {
        modifier(HintModifier(html: html))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some HTML {
        modifier(HintModifier(markdown: markdown))
    }
}

public extension InlineElement {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some InlineElement {
        modifier(HintModifier(text: text))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some InlineElement {
        modifier(HintModifier(html: html))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some InlineElement {
        modifier(HintModifier(markdown: markdown))
    }
}
