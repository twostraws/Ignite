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
public struct HTMLCollection: InlineHTML, BlockHTML, @preconcurrency Sequence {
    /// The content and behavior of this HTML sequence
    public var body: some HTML { self }

    /// How many columns this should occupy when placed in a section
    public var columnWidth: ColumnWidth = .automatic

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
    public func makeIterator() -> IndexingIterator<[any HTML]> {
        elements.makeIterator()
    }

    /// Renders all elements in the sequence into HTML
    /// - Returns: The combined HTML string of all elements
    public func render() -> String {
        elements.map { $0.render() }.joined()
    }
}

extension HTMLCollection {
    /// The type of HTML this element returns after attributes have been applied.
    public typealias AttributedHTML = Self

    public func id(_ id: String) -> Self {
        attributes.id(id)
        return self
    }

    public func `class`(_ classes: String...) -> Self {
        attributes.classes(classes)
        return self
    }
}
