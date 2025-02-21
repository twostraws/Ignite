//
// CoreAttributesModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that merges a set of attributes into the element.
struct CoreAttributesModifier: HTMLModifier {
    let attributes: CoreAttributes

    /// Adds a custom attribute to the element.
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with the style property added
    func body(content: some HTML) -> any HTML {
        let copy = content
        AttributeStore.default.merge(attributes, intoHTML: copy.id)
        return copy
    }
}

extension HTML {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified HTML element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attributes(_ attributes: CoreAttributes) -> some HTML {
        modifier(CoreAttributesModifier(attributes: attributes))
    }
}

extension InlineElement {
    /// Merges a complete set of core attributes into this element.
    /// - Parameter attributes: The CoreAttributes to merge with existing attributes
    /// - Returns: The modified HTML element
    /// - Note: Uses AttributeStore for persistent storage and merging
    func attribute(_ attributes: CoreAttributes) -> some InlineElement {
        modifier(CoreAttributesModifier(attributes: attributes))
    }
}
