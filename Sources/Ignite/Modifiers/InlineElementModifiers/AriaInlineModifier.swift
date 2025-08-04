//
// AriaInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct AriaInlineModifier: InlineElementModifier {
    var key: AriaType
    var value: String?
    func body(content: Content) -> some InlineElement {
        var content = content
        guard let value else { return content }
        content.attributes.aria.append(.init(name: key.rawValue, value: value))
        return content
    }
}

public extension InlineElement {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String) -> some InlineElement {
        modifier(AriaInlineModifier(key: key, value: value))
    }

    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `InlineElement`
    func aria(_ key: AriaType, _ value: String?) -> some InlineElement {
        modifier(AriaInlineModifier(key: key, value: value))
    }
}
