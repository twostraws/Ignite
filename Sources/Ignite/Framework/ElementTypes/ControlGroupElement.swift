//
// ControlGroupElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Describes elements that can be placed into forms.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol ControlGroupElement {
    /// The core attributes for this control element.
    var attributes: CoreAttributes { get set }

    /// Renders the control element as markup.
    /// - Returns: The rendered markup representation.
    func render() -> Markup
}
