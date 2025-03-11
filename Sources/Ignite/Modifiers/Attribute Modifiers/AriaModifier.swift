//
// AriaModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private extension HTML {
    func ariaModifier(key: AriaType, value: String?) -> any HTML {
        guard let value else { return self }
        // Custom elements need to be wrapped in a primitive container to store attributes
        var copy: any HTML = self.isPrimitive ? self : Section(self)
        copy.attributes.aria.append(.init(name: key.rawValue, value: value))
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
        AnyHTML(ariaModifier(key: key, value: value))
    }
}

public extension InlineElement {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String) -> some InlineElement {
        AnyHTML(ariaModifier(key: key, value: value))
    }
}

extension HTML {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String?) -> some HTML {
        AnyHTML(ariaModifier(key: key, value: value))
    }
}

extension InlineElement {
    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String?) -> some InlineElement {
        AnyHTML(ariaModifier(key: key, value: value))
    }
}
