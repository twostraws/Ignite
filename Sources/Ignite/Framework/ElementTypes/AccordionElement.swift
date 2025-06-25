//
// AccordionElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol for elements that can be displayed within an accordion component.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol AccordionElement {
    /// The core attributes associated with this element.
    var attributes: CoreAttributes { get set }

    /// Renders the element as markup.
    /// - Returns: The rendered markup representation.
    func render() -> Markup
}
