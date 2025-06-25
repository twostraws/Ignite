//
// Group.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A transparent grouping construct that propagates modifiers to its children.
///
/// Use `Group` when you want to apply shared modifiers to multiple elements
/// without introducing additional HTML structure. Unlike ``Section``, `Group`
/// doesn't wrap its children in a `div`; instead, it passes modifiers through
/// to each child element.
///
/// - Note: `Group` is particularly useful for applying shared styling or
///         attributes to multiple elements without affecting the document
///         structure. If you need a containing `div` element, use
///         ``Section`` instead.
@MainActor
public struct Group<Content> {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The child elements contained within this group.
    var content: Content
}

extension Group: HTML, Sendable, VariadicHTML where Content: HTML {
    /// Creates a new group containing the given HTML content.
    /// - Parameter content: A closure that creates the HTML content.
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates a new group containing the given HTML content.
    /// - Parameter content: The HTML content to include.
    public init(_ content: Content) {
        self.content = content
    }

    public func render() -> Markup {
        if let content = content as? any VariadicHTML {
            content.subviews.attributes(attributes).render()
        } else {
            content.attributes(attributes).render()
        }
    }

    var subviews: SubviewsCollection {
        var content = (content as? any SubviewsProvider)?.subviews ?? SubviewsCollection(Subview(content))
        content.attributes.merge(attributes)
        return content
    }
}

extension Group: ColumnProvider where Content: ColumnProvider {}

extension Group: LinkProvider where Content: LinkProvider {
    var url: String { content.url }
}
