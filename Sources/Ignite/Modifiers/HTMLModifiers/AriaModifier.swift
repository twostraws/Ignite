//
// AriaModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private struct AriaModifier: HTMLModifier {
    var key: AriaType
    var value: String?
    func body(content: Content) -> some HTML {
        var content = content
        guard let value else { return content }
        content.attributes.aria.append(.init(name: key.rawValue, value: value))
        return content
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

    /// Adds an ARIA attribute to the element.
    /// - Parameters:
    ///   - key: The ARIA attribute key
    ///   - value: The ARIA attribute value
    /// - Returns: The modified `HTML` element
    func aria(_ key: AriaType, _ value: String?) -> some HTML {
        modifier(AriaModifier(key: key, value: value))
    }
}
