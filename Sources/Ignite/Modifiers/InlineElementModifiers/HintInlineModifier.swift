//
// HintInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Modifier that adds hint functionality to inline elements.
private struct HintInlineModifier: InlineElementModifier {
    /// The hint data to apply.
    var data: HintDataType

    func body(content: Content) -> some InlineElement {
        var modified = content
        modified.attributes.append(dataAttributes: data.attributes)
        return modified
    }
}

public extension InlineElement {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some InlineElement {
        modifier(HintInlineModifier(data: .text(text)))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some InlineElement {
        modifier(HintInlineModifier(data: .html(html)))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some InlineElement {
        modifier(HintInlineModifier(data: .markdown(markdown)))
    }
}
