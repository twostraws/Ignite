//
// HeadElementForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
@MainActor
public struct HeadForEach<Data: Sequence>: HeadElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    var items: [HeadElement]

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(
        _ data: Data,
        @HeadElementBuilder content: @escaping (Data.Element) -> [any HeadElement]
    ) {
        self.data = data
        self.items = data.flatMap(content)
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func render() -> Markup {
        items.map {
            var item: any HeadElement = $0
            item.attributes.merge(attributes)
            return item.render()
        }.joined()
    }
}
