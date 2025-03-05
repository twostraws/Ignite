//
// Modifiable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that can be modified with style attributes.
@MainActor public protocol Stylable {
    /// Applies style attributes to this instance.
    /// - Parameter values: A variadic list of style attributes to apply.
    /// - Returns: A new instance with the style attributes applied.
    associatedtype StyledContent: Stylable
    @discardableResult func style(_ property: Property, _ value: String) -> StyledContent
}
