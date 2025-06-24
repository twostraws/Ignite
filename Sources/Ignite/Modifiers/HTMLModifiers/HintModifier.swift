//
// HintModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents different types of hint data for tooltips.
@MainActor
enum HintDataType {
    /// Plain text content.
    case text(String)
    /// HTML content.
    case html(String)
    /// Markdown content that gets converted to HTML.
    case markdown(String)

    /// The HTML attributes required for Bootstrap tooltips.
    var attributes: [Attribute] {
        switch self {
        case .text(let string):
            return [.init(name: "bs-toggle", value: "tooltip"),
             .init(name: "bs-title", value: string)]
        case .html(let string):
            return [.init(name: "bs-toggle", value: "tooltip"),
             .init(name: "bs-title", value: string),
             .init(name: "bs-html", value: "true")]
        case .markdown(let string):
            let parser = MarkdownToHTML(markdown: string, removeTitleFromBody: true)
            let cleanedHTML = parser.body.replacing(#/<\/?p>/#, with: "")
            return Self.html(cleanedHTML).attributes
        }
    }
}

/// Modifier that adds hint functionality to HTML elements.
struct HintModifier: HTMLModifier {
    /// The hint data to apply.
    var data: HintDataType

    func body(content: Content) -> some HTML {
        var modified = content
        modified.attributes.append(dataAttributes: data.attributes)
        return modified
    }
}

public extension HTML {
    /// Creates a plain-text tooltip for this element.
    /// - Parameter text: The text to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(text: String) -> some HTML {
        modifier(HintModifier(data: .text(text)))
    }

    /// Creates a HTML tooltip for this element.
    /// - Parameter html: The HTML to show in the tooltip.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(html: String) -> some HTML {
        modifier(HintModifier(data: .html(html)))
    }

    /// Creates a Markdown tooltip for this element.
    /// - Parameter markdown: The Markdown text to parse.
    /// - Returns: A modified copy of the element with tooltip attached
    func hint(markdown: String) -> some HTML {
        modifier(HintModifier(data: .markdown(markdown)))
    }
}
