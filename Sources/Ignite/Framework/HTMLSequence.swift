//
// HTMLSequence.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that flattens and makes HTML content iterable.
///
/// HTMLSequence is used internally to handle opaque HTML content returned from result builders,
/// particularly in loops and other control flow situations. It converts potentially nested
/// structures into a flat, iterable sequence of HTML elements.
public struct HTMLSequence: InlineElement, BlockElement, @preconcurrency Sequence {
    /// The content and behavior of this HTML sequence
    public var body: some HTML { self }
    
    /// How many columns this should occupy when placed in a section
    public var columnWidth: ColumnWidth = .automatic
    
    /// The array of HTML elements contained in this sequence
    private let elements: [any HTML]
    
    /// Creates a new HTML sequence using a result builder
    /// - Parameter content: A closure that returns HTML content
    public init(@HTMLBuilder _ content: () -> some HTML) {
        let content = content()
        if let group = content as? FlatHTML {
            self.elements = group.elements
        } else if let array = content as? [any HTML] {
            self.elements = array
        } else {
            self.elements = [content]
        }
    }
    
    /// Creates a new HTML sequence from an array of elements
    /// - Parameter elements: The array of HTML elements to include
    public init(_ elements: [any HTML]) {
        self.elements = elements
    }
    
    /// Creates an iterator over the sequence's elements
    /// - Returns: An iterator that provides access to each HTML element
    public func makeIterator() -> IndexingIterator<[any HTML]> {
        elements.makeIterator()
    }
    
    /// Renders all elements in the sequence into HTML
    /// - Parameter context: The current publishing context
    /// - Returns: The combined HTML string of all elements
    public func render(context: PublishingContext) -> String {
        elements.map { element in
            element.render(context: context)
        }.joined()
    }
}
