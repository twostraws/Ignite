//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
public struct ForEach<Data: Sequence, Content: HTML>: InlineHTML, BlockHTML, ListableElement {
    /// The body content created by mapping over the data sequence.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth: ColumnWidth = .automatic

    /// The sequence of data to iterate over.
    private let data: Data

    /// The closure that transforms each data element into HTML content.
    private let content: (Data.Element) -> Content

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(_ data: Data, @HTMLBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Parameter context: The current publishing context.
    /// - Returns: The rendered HTML string.
    public func render(context: PublishingContext) -> String {
        let items = data.map(content)
        return items.map {
            let item: any HTML = $0
            AttributeStore.default.merge(attributes, intoHTML: item.id)
            return item.render(context: context)
        }.joined()
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Parameter context: The current publishing context.
    /// - Returns: The rendered HTML string.
    func renderInList(context: PublishingContext) -> String {
        // ListableElement conformance ensures other views never wrap ForEach in <li> tags.
        render(context: context)
    }
}
