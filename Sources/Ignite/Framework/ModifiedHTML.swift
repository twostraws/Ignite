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
        // We need to ensure that ModifiedHTML always has the attributes of its content.
        // This ensures that when we have nested ModifiedHTML -- all of which wrap
        // some regular primitive type -- the topmost ModifiedHTML has aggregated the attributes
        // of all intermediary ModifiedHTML instances between itself and the original content.
        // For example, if the first modifier in a chain sets the content's grid column width,
        // we want the final ModifiedHTML wrapper to know and respect this value.
        if let modifiedHTML = content as? ModifiedHTML {
            // Merge attributes in case a modifier applied attributes directly
            AttributeStore.default.merge(modifiedHTML.attributes, intoHTML: self.id, excludeTag: true)

            let modifiedContent = modifier.body(content: modifiedHTML)

            // Same here, merge attributes in case body applied attributes directly,
            // rather than to a ModifiedHTML wrapper
            AttributeStore.default.merge(modifiedContent.attributes, intoHTML: self.id, excludeTag: true)
            self.content = content
            return
        }

        let persistableContent = if content.isPrimitive {
            content
        } else {
            // Wrap in a Section so that applied attributes persist
            Section(content)
        }

        // In case this is a primitive type that had attributes applied directly
        AttributeStore.default.merge(persistableContent.attributes, intoHTML: self.id, excludeTag: true)

        // This could be the same type, or a new ModifiedHTML wrapping instance
        let modified = modifier.body(content: persistableContent)

        AttributeStore.default.merge(modified.attributes, intoHTML: self.id, excludeTag: true)

        self.content = modified
    }

    /// Renders this element using the provided publishing context.
    /// - Returns: The rendered HTML string
    func render() -> String {
        // Merge any attributes this ModifiedHTML might be holding to our primitive type
        AttributeStore.default.merge(attributes, intoHTML: content.id)
        return content.render()
    }

    /// Recursively unwraps modified content to find the original underlying type
    var unwrapped: any HTML {
        if let modified = content as? ModifiedHTML {
            return modified.unwrapped
        }
        return content
    }
}
