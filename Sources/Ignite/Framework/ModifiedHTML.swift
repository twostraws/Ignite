//
// ModifiedHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that wraps HTML content with a modifier, preserving attributes and structure.
struct ModifiedHTML: HTML, InlineElement, HeadElement, DocumentElement, NavigationItem {
    /// The content and behavior of this HTML element.
    var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    /// The underlying HTML content being modified.
    var content: any HTML = EmptyHTML()

    /// Creates a new modified HTML element by applying a modifier to existing content.
    /// - Parameters:
    ///   - content: The HTML content to modify
    ///   - modifier: The modifier to apply to the content
    init(_ content: any HTML, modifier: any HTMLModifier) {
        let persistableContent = if content.isPrimitive {
            content
        } else {
            // Wrap in a Section so that applied attributes persist
            Section(content)
        }

        // This could be the same type, or a new type with new attributes
        var modified = modifier.body(content: persistableContent)

        attributes.merge(modified.attributes)

        // Ensure we're not dealing with nested ModifiedHTMLs.
        if let modified = modified as? ModifiedHTML {
            self.content = modified.content
        } else {
            self.content = modified
        }

        // We want only one source of truth for these attributes, the ModifiedHTML wrapper.
        modified.attributes.clear()

        self.content = modified
    }

    /// Renders this element using the provided publishing context.
    /// - Returns: The rendered HTML string
    func render() -> String {
        // Merge any attributes this ModifiedHTML might be holding to our primitive type
        var content = content
        content.attributes.merge(attributes)
        return content.render()
    }

    /// Recursively unwraps modified content to find the original underlying type
    var unwrapped: any HTML {
        if let modified = content as? ModifiedHTML {
            return modified.unwrapped
        }
        if let anyHTML = content as? AnyHTML {
            return anyHTML.wrapped
        }
        return content
    }
}
