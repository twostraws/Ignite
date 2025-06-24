//
// AttributeInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct InlineAttributeModifier: InlineElementModifier {
    var attribute: Attribute?
    func body(content: Content) -> some InlineElement {
        var content = content
        guard let attribute else { return content }
        content.attributes.append(customAttributes: attribute)
        return content
    }
}

public extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the attribute
    ///   - value: The value of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String, _ value: String) -> some InlineElement {
        modifier(InlineAttributeModifier(attribute: .init(name: name, value: value)))
    }

    /// Adds a custom boolean attribute to the element.
    /// - Parameter name: The name of the attribute
    /// - Returns: The modified element
    func attribute(_ name: String) -> some InlineElement {
        modifier(InlineAttributeModifier(attribute: .init(name)))
    }
}

extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> some InlineElement {
        modifier(InlineAttributeModifier(attribute: .init(name: name, value: value)))
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(_ attribute: Attribute?) -> some InlineElement {
        modifier(InlineAttributeModifier(attribute: attribute))
    }
}
