//
// DropdownElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol for elements that can be displayed within dropdown menus.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol DropdownElement {
    /// Core attributes for the dropdown element.
    var attributes: CoreAttributes { get set }

    /// Renders the element as markup.
    /// - Returns: The rendered markup for the element.
    func render() -> Markup
}

/// A protocol for types that render differently when placed inside a dropdown.
@MainActor
protocol DropdownElementRenderable {
    /// Renders the element specifically for dropdown display.
    /// - Returns: The rendered markup optimized for dropdown presentation.
    func renderAsDropdownElement() -> Markup
}
