//
// AttributeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds a custom attribute to the element.
struct AttributeModifier: HTMLModifier {
    let name: String
    let value: String
    /// Adds a custom attribute to the element.
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with the style property added
    func body(content: some HTML) -> any HTML {
        var copy = content
        copy.attributes.customAttributes.append(.init(name: name, value: value))
        AttributeStore.default.merge(copy.attributes, intoHTML: copy.id)
        return copy
    }
}

public extension HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func attribute(_ name: String, _ value: String) -> some HTML {
        modifier(AttributeModifier(name: name, value: value))
    }
}

public extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func attribute(_ name: String, _ value: String) -> some InlineElement {
        modifier(AttributeModifier(name: name, value: value))
    }
}
