//
// VariadicHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that applies transformations to its subviews
/// during rendering.
@MainActor
protocol VariadicHTML {
    /// The subviews of the element's content.
    var subviews: SubviewsCollection { get }
}
