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
public struct Group: PassthroughHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    var items: [any HTML] = []

    public init(@HTMLBuilder _ content: () -> some HTML) {
        self.items = flatUnwrap(content())
    }

    public init(_ items: any HTML) {
        self.items = flatUnwrap(items)
    }

    init(context: PublishingContext, items: [any HTML]) {
        self.items = flatUnwrap(items)
    }

    public func render() -> String {
        items.map {
            let item: any HTML = $0
            AttributeStore.default.merge(attributes, intoHTML: item.id)
            return item.render()
        }.joined()
    }
}
