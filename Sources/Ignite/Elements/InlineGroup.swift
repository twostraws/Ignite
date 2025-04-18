//
// InlineGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A transparent grouping construct that propagates modifiers to its inline children.
///
/// Use `InlineGroup` when you want to apply shared modifiers to multiple inline elements
/// without introducing additional HTML structure. It passes modifiers through
/// to each child element.
///
/// - Note: `InlineGroup` is particularly useful for applying shared styling or
///         attributes to multiple inline elements without affecting the document
///         structure.
public struct InlineGroup: InlineElement, PassthroughElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The child elements contained within this group.
    var items: InlineElementCollection

    public var body: some InlineElement { self }

    /// Creates a new group containing the given inline content.
    /// - Parameter content: A closure that creates the inline content.
    public init(@InlineElementBuilder content: () -> some InlineElement) {
        self.items = InlineElementCollection(content)
    }

    /// Creates a new group containing the given inline content.
    /// - Parameter content: The inline content to include.
    public init(_ content: some InlineElement) {
        self.items = InlineElementCollection([content])
    }

    public func render() -> String {
        items.map {
            var item: any InlineElement = $0
            item.attributes.merge(attributes)
            return item.render()
        }.joined()
    }
}
