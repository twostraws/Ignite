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
