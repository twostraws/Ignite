//
// Hint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some HTML {
        AnyHTML(hintModifier(text: text))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some HTML {
        AnyHTML(hintModifier(html: html))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some HTML {
        AnyHTML(hintModifier(markdown: markdown))
    }
}

public extension InlineElement {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some InlineElement {
        AnyHTML(hintModifier(text: text))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some InlineElement {
        AnyHTML(hintModifier(html: html))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some InlineElement {
        AnyHTML(hintModifier(markdown: markdown))
    }
}

private extension HTML {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A copy of the current element with the tooltip attached.
    func hintModifier(text: String) -> any HTML {
        self
            .data("bs-toggle", "tooltip")
            .data("bs-title", text)
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A copy of the current element with the tooltip attached.
    func hintModifier(html: String) -> any HTML {
        self
            .data("bs-toggle", "tooltip")
            .data("bs-title", html)
            .data("bs-html", "true")
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A copy of the current element with the tooltip attached.

    func hintModifier(markdown: String) -> any HTML {
        let parser = MarkdownToHTML(markdown: markdown, removeTitleFromBody: true)

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
