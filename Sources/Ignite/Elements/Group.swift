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
public struct Group: HTML, PassthroughElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The child elements contained within this group.
    var items: HTMLCollection

    public var body: some HTML { self }

    /// Creates a new group containing the given HTML content.
    /// - Parameter content: A closure that creates the HTML content.
    public init(@HTMLBuilder content: () -> some HTML) {
        self.items = HTMLCollection(content)
    }

    /// Creates a new group containing the given HTML content.
    /// - Parameter content: The HTML content to include.
    public init(_ content: some BodyElement) {
        self.items = HTMLCollection([content])
    }

    public func markup() -> Markup {
        items.map {
            var item: any BodyElement = $0
            item.attributes.merge(attributes)
            return item.markup()
        }.joined()
    }
}
