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

extension PackHTML: HTML, BodyElement, MarkupElement, SubviewsProvider where repeat each Content: HTML {
    /// The content and behavior of this HTML.
    var body: some HTML { self }

    /// Returns the packed elements as a collection of subviews.
    var subviews: SubviewsCollection {
        var children = SubviewsCollection()
        for element in repeat each content {
            // Using the attributes() modifier will change the type to ModifiedHTML,
            // so to keep the type info, we'll modify the attributes directly
            var child = Subview(element)
            child.attributes.merge(attributes)
            children.elements.append(child)
        }
        return children
    }

    /// Renders all packed elements as combined markup.
    func render() -> Markup {
        subviews.map { $0.render() }.joined()
    }
}

extension PackHTML: DropdownElement where repeat each Content: DropdownElement {
    /// Renders all packed dropdown elements as combined markup.
    func render() -> Markup {
        var markup = Markup()
        for var element in repeat each content {
            element.attributes.merge(attributes)
            if let element = element as? any DropdownElementRenderable {
                markup += element.renderAsDropdownElement()
            } else {
                markup += element.render()
            }
        }
        return markup
    }
}
