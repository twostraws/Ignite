//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
@MainActor
public struct ForEach<Data: Sequence, Content> {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    var items: [Content]
}

extension ForEach: HTML, BodyElement, VariadicHTML, Sendable where Content: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(
        _ data: Data,
        @HTMLBuilder content: (Data.Element) -> Content
    ) {
        self.data = data
        self.items = data.map(content)
    }

    var subviews: SubviewsCollection {
        SubviewsCollection(items.map(Subview.init))
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func render() -> Markup {
        subviews.attributes(attributes).render()
    }
}

extension ForEach: TableElement where Content: TableElement {
    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    init(
        _ data: Data,
        @TableElementBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.items = data.map(content)
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func render() -> Markup {
        items.map {
            var item = $0
            item.attributes.merge(attributes)
            return item.render()
        }.joined()
    }
}

extension ForEach: CarouselElement where Content: CarouselElement {
    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    init(
        _ data: Data,
        @CarouselElementBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.items = data.map(content)
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func render() -> Markup {
        items.map {
            var item = $0
            item.attributes.merge(attributes)
            return item.render()
        }.joined()
    }
}

extension ForEach: ListItemProvider where Content: ListItemProvider {}

extension ForEach: ColumnProvider where Content: ColumnProvider {}
