//
// CarouselElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol for elements that can be displayed in a carousel.
/// - Warning: Do not conform to this type directly.
@MainActor
public protocol CarouselElement {
    /// The core attributes for styling and configuration.
    var attributes: CoreAttributes { get set }

    /// Renders the element as markup.
    /// - Returns: The rendered markup representation.
    func render() -> Markup
}

extension CarouselElement {
    /// Creates a collection containing this element as a subview.
    /// - Returns: A carousel subviews collection.
    func subviews() -> CarouselSubviewsCollection {
        CarouselSubviewsCollection(self)
    }
}
