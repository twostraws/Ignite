//
// Hint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
private func hintModifier(text: String, content: any HTML) -> any HTML {
    content
        .data("bs-toggle", "tooltip")
        .data("bs-title", text)
}

@MainActor
private func hintModifier(html: String, content: any HTML) -> any HTML {
    content
        .data("bs-toggle", "tooltip")
        .data("bs-title", html)
        .data("bs-html", "true")
}

@MainActor
private func hintModifier(markdown: String, content: any HTML) -> any HTML {
    let parser = MarkdownToHTML(markdown: markdown, removeTitleFromBody: true)
    let cleanedHTML = parser.body.replacing(#/<\/?p>/#, with: "")

    return content
        .data("bs-toggle", "tooltip")
        .data("bs-title", cleanedHTML)
        .data("bs-html", "true")
}

@MainActor
private func hintModifier(text: String, content: any InlineElement) -> any InlineElement {
    content
        .data("bs-toggle", "tooltip")
        .data("bs-title", text)
}

@MainActor
private func hintModifier(html: String, content: any InlineElement) -> any InlineElement {
    content
        .data("bs-toggle", "tooltip")
        .data("bs-title", html)
        .data("bs-html", "true")
}

@MainActor
private func hintModifier(markdown: String, content: any InlineElement) -> any InlineElement {
    let parser = MarkdownToHTML(markdown: markdown, removeTitleFromBody: true)
    let cleanedHTML = parser.body.replacing(#/<\/?p>/#, with: "")

    return content
        .data("bs-toggle", "tooltip")
        .data("bs-title", cleanedHTML)
        .data("bs-html", "true")
}

public extension HTML {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some HTML {
        AnyHTML(hintModifier(text: text, content: self))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some HTML {
        AnyHTML(hintModifier(html: html, content: self))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some HTML {
        AnyHTML(hintModifier(markdown: markdown, content: self))
    }
}

public extension InlineElement {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some InlineElement {
        AnyInlineElement(hintModifier(text: text, content: self))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some InlineElement {
        AnyInlineElement(hintModifier(html: html, content: self))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some InlineElement {
        AnyInlineElement(hintModifier(markdown: markdown, content: self))
    }
}
