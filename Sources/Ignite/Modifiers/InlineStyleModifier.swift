//
// InlineStyleModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that applies inline styles to an HTML element.
struct InlineStyleModifier: HTMLModifier {
    var property: Property
    var value: String

    func body(content: some HTML) -> any HTML {
        content.style(.init(name: property, value: value))
    }
}

public extension HTML {
    /// Applies an inline style to the HTML element.
    /// - Parameters:
    ///   - name: The CSS property to set.
    ///   - value: The value for the CSS property.
    /// - Returns: A modified HTML element with the specified style.
    func style(_ name: Property, _ value: String) -> some HTML {
        modifier(InlineStyleModifier(property: name, value: value))
    }
}

public extension InlineHTML {
    /// Applies an inline style to the inline HTML element.
    /// - Parameters:
    ///   - name: The CSS property to set.
    ///   - value: The value for the CSS property.
    /// - Returns: A modified HTML element with the specified style.
    func style(_ name: Property, _ value: String) -> some InlineHTML {
        modifier(InlineStyleModifier(property: name, value: value))
    }
}

public extension BlockHTML {
    /// Applies an inline style to the inline HTML element.
    /// - Parameters:
    ///   - name: The CSS property to set.
    ///   - value: The value for the CSS property.
    /// - Returns: A modified HTML element with the specified style.
    func style(_ name: Property, _ value: String) -> some BlockHTML {
        modifier(InlineStyleModifier(property: name, value: value))
    }
}
