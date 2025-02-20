//
// AttributeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds a custom attribute to the element.
struct AttributeModifier: HTMLModifier {
    let name: String
    let value: String?
    /// Adds a custom attribute to the element.
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with the style property added
    func body(content: some HTML) -> any HTML {
        var copy = content
        let attribute: Attribute = if let value {
            .init(name: name, value: value)
        } else {
            .init(name)
        }
        copy.descriptor.customAttributes.append(attribute)
        DescriptorStorage.shared.merge(copy.descriptor, intoHTML: copy.id)
        return copy
    }
}

public extension HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the attribute
    ///   - value: The value of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String, _ value: String) -> some HTML {
        modifier(AttributeModifier(name: name, value: value))
    }

    /// Adds a custom boolean attribute to the element.
    /// - Parameter name: The name of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String) -> some HTML {
        modifier(AttributeModifier(name: name, value: nil))
    }
}

public extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the attribute
    ///   - value: The value of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String, _ value: String) -> some InlineElement {
        modifier(AttributeModifier(name: name, value: value))
    }

    /// Adds a custom boolean attribute to the element.
    /// - Parameter name: The name of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String) -> some InlineElement {
        modifier(AttributeModifier(name: name, value: nil))
    }
}
