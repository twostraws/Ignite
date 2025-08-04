//
// ButtonElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol for elements that can be rendered as interactive buttons.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol ButtonElement {
    /// The core attributes applied to this button element.
    var attributes: CoreAttributes { get set }

    /// Renders the button element as markup.
    /// - Returns: The rendered markup representation.
    func render() -> Markup
}
