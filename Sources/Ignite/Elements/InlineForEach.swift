//
// InlineForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates inline content by mapping over a sequence of data.
@MainActor
public struct InlineForEach<Data: Sequence, Content: InlineElement>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    private var items: [Content]

    /// Creates a new InlineForEach instance that generates inline content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into inline content.
    public init(_ data: Data, @InlineElementBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.items = data.map(content)
    }

    /// Renders the ForEach content.
    /// - Returns: The rendered HTML string.
    public func render() -> Markup {
        items.map {
            var item = $0
            item.attributes.merge(attributes)
            return item.render()
        }.joined()
    }
}
