//
// HTMLSequence.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that flattens and makes HTML content iterable.
///
/// `HTMLCollection` is used internally to handle opaque HTML content returned from result builders,
/// particularly in loops and other control flow situations. It converts potentially nested
/// structures into a flat, iterable collections of `HTML` elements.
struct HTMLCollection: InlineElement, @preconcurrency Sequence {
    /// The content and behavior of this HTML sequence
    var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    /// The array of HTML elements contained in this sequence
    var elements: [any HTML]

    /// Creates a new HTML sequence using a result builder
    /// - Parameter content: A closure that returns HTML content
    init(@HTMLBuilder _ content: () -> some HTML) {
        let content = content()
        self.init(content)
    }

    /// Creates a new HTML sequence from an array of elements
    /// - Parameter elements: The array of HTML elements to include
    init(_ elements: [any HTML]) {
        self.elements = flatUnwrap(elements)
    }

    init(_ content: any HTML) {
        self.elements = flatUnwrap(content)
    }

    /// Creates an iterator over the sequence's elements
    /// - Returns: An iterator that provides access to each HTML element
    func makeIterator() -> IndexingIterator<[any HTML]> {
        elements.makeIterator()
    }

    /// Renders all elements in the sequence into HTML
    /// - Returns: The combined HTML string of all elements
    func render() -> String {
        elements.map {
            var item: any HTML = $0
            item.attributes.merge(attributes)
            return item.render()
        }.joined()
    }
}
