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
public struct Group<Content: HTML>: PassthroughElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    var items: HTMLCollection

    public init(@HTMLBuilder _ content: () -> Content) {
        self.items = HTMLCollection(content)
    }

    public init(_ items: Content) {
        self.items = HTMLCollection([items])
    }

    public func render() -> String {
        items.map {
            var item: any HTML = $0
            item.attributes.merge(attributes)
            return item.render()
        }.joined()
    }
}

extension Group: InlineElement where Content: InlineElement {
    public init(@InlineElementBuilder _ content: () -> Content) {
        self.items = HTMLCollection(content)
    }
}
