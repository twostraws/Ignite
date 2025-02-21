//
// AttributeModifier-Internal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension HTML {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> some HTML {
        modifier(AttributeModifier(attribute: .init(name: name, value: value)))
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(_ attribute: Attribute?) -> some HTML {
        modifier(AttributeModifier(attribute: attribute))
    }
}

extension InlineElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> some InlineElement {
        modifier(AttributeModifier(attribute: .init(name: name, value: value)))
    }

    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(_ attribute: Attribute?) -> some HTML {
        modifier(AttributeModifier(attribute: attribute))
    }
}

extension HeadElement {
    /// Adds a custom attribute to the element.
    /// - Parameters:
    ///   - name: The name of the custom attribute
    ///   - value: The value of the custom attribute
    /// - Returns: The modified `HTML` element
    func customAttribute(name: String, value: String) -> some HeadElement {
        modifier(AttributeModifier(attribute: .init(name: name, value: value)))
    }
}
