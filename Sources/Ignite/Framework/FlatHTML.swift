//
// HTMLGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A container that combines multiple HTML elements into a single unit, conforming to InlineElement,
/// BlockElement, and Sequence protocols. Used internally by result builders to combine multiple elements.
public struct FlatHTML: InlineElement, BlockElement, @preconcurrency Sequence {
    /// The content and behavior of this HTML.
    public var body: some HTML { FlatHTML(elements) }
    
    /// How many columns this should occupy when placed in a section.
    public var columnWidth: ColumnWidth = .automatic
    
    /// The array of HTML elements contained within this group.
    var elements: [any HTML]
    
    /// Creates a new HTML group from an array of elements
    /// - Parameter elements: The array of HTML elements to include in the group
    init(_ elements: [any HTML]) {
        self.elements = elements
    }
    
    /// Creates a new HTML group from a result builder closure
    /// - Parameter content: A closure that returns HTML content using the @HTMLBuilder result builder
    init(@HTMLBuilder _ content: () -> some HTML) {
        if let group = content() as? FlatHTML {
            self.elements = group.elements
        } else {
            self.elements = [content()]
        }
    }
    
    /// Creates a new HTML group from a single HTML element or sequence
    /// - Parameter content: A single HTML element, HTMLGroup, AnyHTML, or sequence of HTML elements
    init(_ content: any HTML) {
        if let group = content as? FlatHTML {
            self.elements = group.elements
        } else if let anyHTML = content as? AnyHTML {
            // Unwrap AnyHTML content and handle directly
            if let nestedGroup = anyHTML.wrapped as? FlatHTML {
                self.elements = nestedGroup.elements
            } else {
                self.elements = [anyHTML.wrapped]
            }
        } else if let array = content as? [AnyHTML] {
            // Handle array of AnyHTML by unwrapping each one
            self.elements = array.map { $0.wrapped }
        } else if let sequence = content as? any Sequence<any HTML> {
            self.elements = Array(sequence)
        } else {
            self.elements = [content]
        }
    }
    
    public func makeIterator() -> IndexingIterator<[any HTML]> {
        elements.makeIterator()
    }
    
    public func render(context: PublishingContext) -> String {
        return elements.map { element in
            element.render(context: context)
        }.joined()
    }
}
