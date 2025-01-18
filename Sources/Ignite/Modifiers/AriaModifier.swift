//
// AriaModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds ARIA attributes to an HTML element.
struct AriaModifier: HTMLModifier {
    let key: String
    let value: String

    func body(content: some HTML) -> any HTML {
        content._aria(key, value)
    }
}

public extension HTML {
    /// Adds an ARIA attribute to the HTML element.
    /// - Parameters:
    ///   - key: The ARIA attribute name (without the "aria-" prefix).
    ///   - value: The value for the ARIA attribute.
    /// - Returns: A modified HTML element with the specified ARIA attribute.
    func aria(_ key: String, _ value: String) -> some HTML {
        modifier(AriaModifier(key: key, value: value))
    }
}

public extension InlineHTML {
    /// Adds an ARIA attribute to the inline HTML element.
    /// - Parameters:
    ///   - key: The ARIA attribute name (without the "aria-" prefix).
    ///   - value: The value for the ARIA attribute.
    /// - Returns: A modified HTML element with the specified ARIA attribute.
    func aria(_ key: String, _ value: String) -> some InlineHTML {
        modifier(AriaModifier(key: key, value: value))
    }
}

public extension BlockHTML {
    /// Adds an ARIA attribute to the block HTML element.
    /// - Parameters:
    ///   - key: The ARIA attribute name (without the "aria-" prefix).
    ///   - value: The value for the ARIA attribute.
    /// - Returns: A modified HTML element with the specified ARIA attribute.
    func aria(_ key: String, _ value: String) -> some BlockHTML {
        modifier(AriaModifier(key: key, value: value))
    }
}
