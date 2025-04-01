//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
public struct ForEach<Data: Sequence, Content: HTML>: PassthroughElement, ListableElement, HeadElement {
    /// The body content created by mapping over the data sequence.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The sequence of data to iterate over.
    private let data: Data

    /// The child elements contained within this HTML element.
    var items: HTMLCollection

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(_ data: Data, @HTMLBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.items = HTMLCollection(data.map(content))
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func render() -> String {
        return items.map {
            var item: any HTML = $0
            item.attributes.merge(attributes)
            return item.render()
        }.joined()
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    func renderInList() -> String {
        // ListableElement conformance ensures other views never wrap ForEach in <li> tags.
        render()
    }
}

extension ForEach: InlineElement where Content: InlineElement {
    /// Creates a new `ForEach` instance that generates inline content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into inline content.
    public init(_ data: Data, @InlineElementBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.items = HTMLCollection(data.map(content))
    }
}
