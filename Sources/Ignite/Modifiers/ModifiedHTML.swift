//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that wraps HTML content with a modifier, preserving attributes and structure.
public struct ModifiedHTML: HTML, InlineHTML, BlockHTML, RootHTML, NavigationItem {
    /// The column width to use when this element appears in a grid layout.
    public var columnWidth: ColumnWidth = .automatic

    /// A unique identifier for this element.
    public var id = UUID().uuidString.truncatedHash

    /// The content and behavior of this HTML element.
    public var body: some HTML { self }

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool = true

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

        let modifiedContent: any HTML = modifier.body(content: self)
        AttributeStore.default.merge(modifiedContent.attributes, intoHTML: id)

        if let block = self.content as? (any BlockHTML) {
            self.columnWidth = block.columnWidth
        }
    }

    /// Renders this element using the provided publishing context.
    /// - Returns: The rendered HTML string
    public func render() -> String {
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

public extension ModifiedHTML {
    func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: id)
        return self
    }

    func data(_ name: String, _ value: String) -> Self {
        attributes.data(name, value, persistentID: id)
        return self
    }

    func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: id)
        return self
    }
}
