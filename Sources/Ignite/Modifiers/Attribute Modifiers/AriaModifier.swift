//
// AriaModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds an ARIA attribute to the element.
struct AriaModifier: HTMLModifier {
    let key: AriaType
    let value: String?
    /// Adds an ARIA attribute to the element.
    /// - Parameter content: The HTML element to modify
    /// - Returns: The modified HTML with the style property added
    func body(content: some HTML) -> any HTML {
        guard let value else { return content }
        var copy = content
        copy.attributes.aria.insert(Attribute(name: key.rawValue, value: value))
        return copy
    }
}

public extension HTML {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String) -> some HTML {
        modifier(AriaModifier(key: key, value: value))
    }
}

public extension InlineElement {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String) -> some InlineElement {
        modifier(AriaModifier(key: key, value: value))
    }
}
