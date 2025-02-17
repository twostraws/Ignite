//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that wraps HTML content with a modifier, preserving attributes and structure.
struct ModifiedHTML: HTML, InlineElement, RootElement, NavigationItem {
    /// The column width to use when this element appears in a grid layout.
    var columnWidth: ColumnWidth = .automatic

    /// A unique identifier for this element.
    var id = UUID().uuidString.truncatedHash

    /// The content and behavior of this HTML element.
    var body: some HTML { self }

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    /// The underlying HTML content being modified.
    private(set) var content: any HTML

    /// Creates a new modified HTML element by applying a modifier to existing content.
    /// - Parameters:
    ///   - content: The HTML content to modify
    ///   - modifier: The modifier to apply to the content
    init(_ content: any HTML, modifier: any HTMLModifier) {
        if content.isPrimitive {
            self.id = content.id
        }

        self.content = if let modified = content as? ModifiedHTML {
            modified.content
        } else {
            content
        }

        _ = modifier.body(content: self)
    }

    /// Renders this element using the provided publishing context.
    /// - Returns: The rendered HTML string
    func render() -> String {
        if content.isPrimitive {
            AttributeStore.default.merge(attributes, intoHTML: content.id)
            return content.render()
        } else {
            let rawContent = content.render()
            var attrs = attributes
            if attrs.tag == nil { attrs.tag = "div" }
            return attrs.description(wrapping: rawContent)
        }
    }
}
