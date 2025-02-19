//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that wraps HTML content with a modifier, preserving attributes and structure.
struct ModifiedHTML: HTML, InlineElement, DocumentElement, NavigationItem {
    /// A unique identifier for this element.
    var id = UUID().uuidString

    /// The content and behavior of this HTML element.
    var body: some HTML { self }

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    /// The underlying HTML content being modified.
    private(set) var content: any HTML = EmptyHTML()

    /// Creates a new modified HTML element by applying a modifier to existing content.
    /// - Parameters:
    ///   - content: The HTML content to modify
    ///   - modifier: The modifier to apply to the content
    init(_ content: any HTML, modifier: any HTMLModifier) {
        let unwrapped: any HTML
        if let modified = content as? ModifiedHTML {
            self.id = modified.id
            unwrapped = modified.content
        } else {
            unwrapped = content
        }

        let modified: any HTML
        if unwrapped.isPrimitive {
            modified = modifier.body(content: unwrapped)
            self.content = modified
        } else {
            // Store attributes
            _ = modifier.body(content: self)
            self.content = unwrapped
        }
    }

    /// Renders this element using the provided publishing context.
    /// - Returns: The rendered HTML string
    func render() -> String {
        if content.isPrimitive {
            return content.render()
        } else {
            let rawContent = content.render()
            var attrs = attributes
            if attrs.tag == nil { attrs.tag = "div" }
            return attrs.description(wrapping: rawContent)
        }
    }
}
