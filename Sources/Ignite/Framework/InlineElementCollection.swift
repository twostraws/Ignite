//
// InlineElementCollection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that flattens and makes HTML content iterable.
///
/// `HTMLCollection` is used internally to handle opaque HTML content returned from result builders,
/// particularly in loops and other control flow situations. It converts potentially nested
/// structures into a flat, iterable collections of `HTML` elements.
struct InlineElementCollection: InlineElement, @preconcurrency Sequence {
    /// The content and behavior of this HTML sequence
    var body: some InlineElement { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    var isPrimitive: Bool { true }

    /// The array of HTML elements contained in this sequence
    var elements: [any InlineElement] = []

    /// The array of HTML elements with the container's attributes applied.
    var attributedElements: [any InlineElement] {
        elements.map {
            var item: any InlineElement = $0
            item.attributes.merge(attributes)
            return item
        }
    }

    /// Creates a new HTML sequence using a result builder
    /// - Parameter content: A closure that returns HTML content
    init(@InlineElementBuilder _ content: () -> some InlineElement) {
        let content = content()
        self.elements = flatten(content)
    }

    /// Creates a new HTML sequence from an array of elements
    /// - Parameter elements: The array of HTML elements to include
    init(_ elements: [any InlineElement]) {
        self.elements = elements.flatMap { flatten($0) }
    }

    /// Creates an iterator over the sequence's elements
    /// - Returns: An iterator that provides access to each HTML element
    func makeIterator() -> IndexingIterator<[any InlineElement]> {
        elements.makeIterator()
    }

    /// Renders all elements in the sequence into HTML
    /// - Returns: The combined HTML string of all elements
    func markup() -> Markup {
        elements.map {
            var item: any InlineElement = $0
            item.attributes.merge(attributes)
            return item.markup()
        }.joined()
    }

    /// Recursively flattens nested HTML content into a single array, deconstructing wrapper types.
    /// - Parameter content: The content to flatten
    /// - Returns: An array of unwrapped HTML elements
    private func flatten(_ content: any InlineElement) -> [any InlineElement] {
        if let anyHTML = content as? AnyInlineElement {
            flatten(anyHTML.attributedContent)
        } else if let collection = content as? InlineElementCollection {
            collection.attributedElements.flatMap { flatten($0) }
        } else if content is EmptyInlineElement {
            []
        } else {
            [content]
        }
    }
}
