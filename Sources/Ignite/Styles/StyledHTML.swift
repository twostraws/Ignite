//
// StyledHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A concrete type used for style resolution that only holds attributes
@MainActor public struct StyledHTML {
    /// A collection of styles.
    var styles = [InlineStyle]()

    /// Adds inline styles to the element.
    /// - Parameter values: Variable number of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    public func style(_ property: Property, _ value: String) -> Self {
        var copy = self
        copy.styles.append(.init(property, value: value))
        return copy
    }
}

extension StyledHTML {
    /// Adds inline styles to the element.
    /// - Parameter values: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ styles: [InlineStyle]) -> Self {
        var copy = self
        copy.styles.append(contentsOf: styles)
        return copy
    }

    /// Adds inline styles to the element.
    /// - Parameter values: An array of `InlineStyle` objects
    /// - Returns: The modified `HTML` element
    func style(_ styles: InlineStyle...) -> Self {
        var copy = self
        copy.styles.append(contentsOf: styles)
        return copy
    }
}
