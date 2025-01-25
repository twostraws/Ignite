//
// ForEach.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that creates HTML content by mapping over a sequence of data.
public struct ForEach<Data: Sequence, Content: HTML>: InlineHTML, PassthroughHTML, ListableElement {
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

    /// The child elements contained within this HTML element.
    var items: [any HTML] { data.map(content) }

    /// Creates a new ForEach instance that generates HTML content from a sequence.
    /// - Parameters:
    ///   - data: The sequence to iterate over.
    ///   - content: A closure that converts each element into HTML content.
    public init(_ data: Data, @HTMLBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    /// Renders the ForEach content when this isn't part of a list.
    /// - Returns: The rendered HTML string.
    public func render() -> String {
        let items = data.map(content)
        return items.map {
            let item: any HTML = $0
            AttributeStore.default.merge(attributes, intoHTML: item.id)
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

extension ForEach {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    public func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: id)
        return self
    }

    public func data(_ name: String, _ value: String) -> Self {
        attributes.data(name, value, persistentID: id)
        return self
    }

    public func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: id)
        return self
    }
}
