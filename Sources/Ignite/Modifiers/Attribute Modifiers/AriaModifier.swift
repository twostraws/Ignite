//
// AriaModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func ariaModifier(
    _ key: AriaType,
    value: String?,
    content: any BodyElement
) -> any BodyElement {
    guard let value else { return content }
    var copy: any BodyElement = content.isPrimitive ? content : Section(content)
    copy.attributes.aria.append(.init(name: key.rawValue, value: value))
    return copy
}

@MainActor private func ariaModifier(
    _ key: AriaType,
    value: String?,
    content: any InlineElement
) -> any InlineElement {
    guard let value else { return content }
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.aria.append(.init(name: key.rawValue, value: value))
    return copy
}

public extension HTML {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String) -> some HTML {
        AnyHTML(ariaModifier(key, value: value, content: self))
    }

    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String?) -> some HTML {
        AnyHTML(ariaModifier(key, value: value, content: self))
    }
}

public extension InlineElement {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String) -> some InlineElement {
        AnyInlineElement(ariaModifier(key, value: value, content: self))
    }

    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `InlineElement`
    func aria(_ key: AriaType, _ value: String?) -> some InlineElement {
        AnyInlineElement(ariaModifier(key, value: value, content: self))
    }
}
