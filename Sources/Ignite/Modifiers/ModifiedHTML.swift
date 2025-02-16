//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that wraps HTML content with a modifier, preserving attributes and structure.
struct ModifiedHTML: HTML, InlineElement, BlockHTML, RootElement, NavigationItem {
    /// The column width to use when this element appears in a grid layout.
    var columnWidth: ColumnWidth = .automatic

    /// A unique identifier for this element.
    var id = UUID().uuidString.truncatedHash

    /// The content and behavior of this HTML element.
    var body: some HTML { self }

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool = true

    /// The underlying HTML content being modified.
    private(set) var content: any HTML

    /// Creates a new modified HTML element by applying a modifier to existing content.
    /// - Parameters:
    ///   - content: The HTML content to modify
    ///   - modifier: The modifier to apply to the content
    init(_ content: any HTML, modifier: any HTMLModifier) {
        if let modified = content as? ModifiedHTML {
            self.content = modified.content
            AttributeStore.default.merge(modified.attributes, intoHTML: id)
        } else {
            self.content = content
            AttributeStore.default.merge(content.attributes, intoHTML: id)
        }

        _ = modifier.body(content: self)

        if let block = self.content as? (any BlockHTML) {
            self.columnWidth = block.columnWidth
        }
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
