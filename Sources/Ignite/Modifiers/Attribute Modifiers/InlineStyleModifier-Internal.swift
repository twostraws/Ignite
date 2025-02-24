//
// InlineStyleModifier-Internal.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension HTML {
    /// Adds an inline style to the element.
    /// - Parameters:
    ///   - property: The CSS property.
    ///   - value: The value.
    /// - Returns: The modified `HTML` element
    func style(_ property: String, _ value: String) -> some HTML {
        modifier(InlineStyleModifier(styles: [.init(property, value: value)]))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ values: InlineStyle?...) -> some HTML {
        let styles = values.compactMap(\.self)
        return modifier(InlineStyleModifier(styles: styles))
    }

    /// Adds inline styles to the element.
    /// - Parameter values: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ values: [InlineStyle]) -> some HTML {
        modifier(InlineStyleModifier(styles: values))
    }
}
