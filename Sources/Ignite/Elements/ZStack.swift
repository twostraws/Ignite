//
// ZStack.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates a container that stacks its children along the z-axis (depth),
/// with each subsequent child appearing in front of the previous one.
public struct ZStack: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth: ColumnWidth = .automatic

    /// The alignment point for positioning elements within the stack.
    private var alignment: UnitPoint

    /// The child elements to be stacked.
    private var items: [any HTML] = []

    /// Creates a new ZStack with the specified alignment and content.
    /// - Parameters:
    ///   - alignment: The point within the stack where elements should be aligned (default: .center).
    ///   - items: A closure that returns the elements to be stacked.
    public init(alignment: UnitPoint = .center, @HTMLBuilder _ items: () -> some HTML) {
        self.items = flatUnwrap(items())
        self.alignment = alignment
    }

    public func render(context: PublishingContext) -> String {
        var items = [any HTML]()

        for item in self.items {
            if let modified = item as? ModifiedHTML {
                items.append(modified.content)
            } else if let container = item as? HTMLCollection {
                items.append(contentsOf: container.elements)
            } else {
                items.append(item)
            }
        }

        items.enumerated().forEach { index, item in
            var elementAttributes = CoreAttributes()
            elementAttributes.append(styles: [
                .init(name: "grid-area", value: "1/1"),
                .init(name: "z-index", value: "\(index)"),
                .init(name: "width", value: "fit-content"),
                .init(name: "height", value: "fit-content"),
                .init(name: "justify-self", value: alignment.justifySelf),
                .init(name: "align-self", value: alignment.alignSelf)
            ])

            AttributeStore.default.merge(elementAttributes, intoHTML: item.id)
        }

        var attributes = attributes
        attributes.append(styles: .init(name: "display", value: "grid"))

        AttributeStore.default.merge(attributes, intoHTML: id)
        attributes.tag = "div"

        let content = items.map { $0.render(context: context) }.joined()
        return attributes.description(wrapping: content)
    }
}
