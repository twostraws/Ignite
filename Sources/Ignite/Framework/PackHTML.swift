//
// PackHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that packs multiple HTML elements together.
///
/// Use `PackHTML` to group HTML elements while maintaining their individual types
/// and applying shared attributes across all contained elements.
@MainActor
struct PackHTML<each Content>: Sendable { // swiftlint:disable:this redundant_sendable
    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The tuple of elements stored by this type.
    var content: (repeat each Content)

    /// Creates a new pack with the specified HTML content.
    /// - Parameter content: The HTML elements to pack together.
    init(_ content: repeat each Content) {
        self.content = (repeat each content)
    }
}

extension PackHTML: HTML, BodyElement, MarkupElement where repeat each Content: HTML {
    /// The content and behavior of this HTML.
    var body: some HTML { self }

    /// Renders all packed elements as combined markup.
    func render() -> Markup {
        var markup = Markup()
        for element in repeat each content {
            markup += element.attributes(attributes).render()
        }
        return markup
    }
}
