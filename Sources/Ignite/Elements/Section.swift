//
// GroupBox.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container element that wraps its children in a `div` element.
///
/// Use `Section` when you want to group elements together and have them rendered
/// within a containing HTML `div`. This is useful for applying shared styling,
/// creating layout structures, or logically grouping related content.
///
/// - Note: Unlike ``Group``, modifiers applied to a `Section` affect the
///         containing `div` element rather than being propagated to child elements.
public struct Section: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    var items: [any HTML] = []

    public init(@HTMLBuilder content: () -> some HTML) {
        self.items = flatUnwrap(content())
    }

    public init(_ items: any HTML) {
        self.items = flatUnwrap(items)
    }

    public func render() -> String {
        let content = items.map { $0.render() }.joined()
        var attributes = attributes
        attributes.tag = "div"
        return attributes.description(wrapping: content)
    }
}
