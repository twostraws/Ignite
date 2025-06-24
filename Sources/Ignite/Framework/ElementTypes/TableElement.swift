//
// TableElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into tables
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol TableElement {
    /// Core attributes for the table-row element.
    var attributes: CoreAttributes { get set }

    /// Renders the element as markup.
    /// - Returns: The rendered markup for the element.
    func render() -> Markup
}
