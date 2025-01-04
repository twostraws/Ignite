//
// StyledHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A concrete type used for style resolution that only holds attributes
public struct StyledHTML {
    /// A collection of styles, classes, and attributes.
    var attributes = CoreAttributes()

    /// Applies a style value for a given property
    /// - Parameters:
    ///   - value: The CSS value to apply
    ///   - property: The CSS property to set
    /// - Returns: A modified instance with the new style applied
    public func style(_ property: Property, _ value: String) -> Self {
        var copy = self
        copy.attributes.append(style: property.rawValue, value: value)
        return copy
    }
}
