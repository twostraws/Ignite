//
// CustomAttributeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds custom attributes to an HTML element.
struct CustomAttributeModifier: HTMLModifier {
    let name: Property
    let value: String

    func body(content: some HTML) -> any HTML {
        content.customAttribute(name: name, value: value)
    }
}

public extension HTML {
    /// Adds a custom attribute to the HTML element.
    /// - Parameters:
    ///   - name: The name of the attribute.
    ///   - value: The value for the attribute.
    /// - Returns: A modified HTML element with the specified attribute.
    func customAttribute(_ name: Property, _ value: String) -> some HTML {
        modifier(CustomAttributeModifier(name: name, value: value))
    }
}

public extension InlineHTML {
    /// Adds a custom attribute to the inline HTML element.
    /// - Parameters:
    ///   - name: The name of the attribute.
    ///   - value: The value for the attribute.
    /// - Returns: A modified HTML element with the specified attribute.
    func customAttribute(_ name: Property, _ value: String) -> some InlineHTML {
        modifier(CustomAttributeModifier(name: name, value: value))
    }
}

public extension BlockHTML {
    /// Adds a custom attribute to the block HTML element.
    /// - Parameters:
    ///   - name: The name of the attribute.
    ///   - value: The value for the attribute.
    /// - Returns: A modified HTML element with the specified attribute.
    func customAttribute(_ name: Property, _ value: String) -> some BlockHTML {
        modifier(CustomAttributeModifier(name: name, value: value))
    }
}
