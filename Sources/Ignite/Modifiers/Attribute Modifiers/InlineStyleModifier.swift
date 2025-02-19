//
// InlineStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds an inline CSS style property to an HTML element.
struct InlineStyleModifier: HTMLModifier {
    let property: Property
    let value: String
    /// Adds the specified CSS style property to the HTML element
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with the style property added
    func body(content: some HTML) -> any HTML {
        var copy = content
        copy.attributes.styles.append(.init(property, value: value))
        AttributeStore.default.merge(copy.attributes, intoHTML: copy.id)
        return copy
    }
}

public extension HTML {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some HTML {
        modifier(InlineStyleModifier(property: property, value: value))
    }
}

public extension InlineElement {
    /// Adds an inline CSS style property to the HTML element
    /// - Parameters:
    ///   - property: The CSS property to set
    ///   - value: The value to set for the property
    /// - Returns: A modified copy of the element with the style property added
    func style(_ property: Property, _ value: String) -> some InlineElement {
        modifier(InlineStyleModifier(property: property, value: value))
    }
}
