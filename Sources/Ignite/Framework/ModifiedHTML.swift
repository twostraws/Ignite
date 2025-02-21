//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that wraps HTML content with a modifier, preserving attributes and structure.
struct ModifiedHTML: HTML, InlineElement, HeadElement, DocumentElement, NavigationItem {
    /// A unique identifier for this element.
    var id = UUID().uuidString

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
            self.content = modifier.body(content: content)
        } else {
            // Wrap in a Section so that applied attributes persist
            self.content = modifier.body(content: Section(content))
        }
    }

    /// Renders this element using the provided publishing context.
    /// - Returns: The rendered HTML string
    func render() -> String {
        if content.isPrimitive {
            // Merge any attributes this ModifiedHTML might be holding to our primitive type
            AttributeStore.default.merge(attributes, intoHTML: content.id)
            return content.render()
        } else {
            return content.render()
        }
    }

    /// Recursively unwraps modified content to find the original underlying type
    var unwrapped: any HTML {
        if let modified = content as? ModifiedHTML {
            return modified.unwrapped
        }
        return content
    }
}
