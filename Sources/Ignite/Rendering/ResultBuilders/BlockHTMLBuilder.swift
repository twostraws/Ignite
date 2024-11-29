//
// BlockElementBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A result builder that enables declarative syntax for constructing block-level HTML elements.
///
/// This builder provides support for creating complex hierarchies of block elements using
/// a SwiftUI-like syntax, handling common control flow patterns like conditionals and loops.
@MainActor
@resultBuilder
public struct BlockHTMLBuilder {
    /// Converts a single block element into a builder expression.
    /// - Parameter content: The block element to convert
    /// - Returns: The same block element, unchanged
    public static func buildExpression<Content: BlockHTML>(_ content: Content) -> Content {
        content
    }

    /// Combines multiple block elements into a single builder expression.
    /// - Parameter content: The block elements to combine
    /// - Returns: A combined block element containing all inputs
    static func buildBlock<Content: BlockHTML>(_ content: Content...) -> some BlockHTML {
        return content
    }

    /// Creates an empty block element when no content is provided.
    /// - Returns: An empty block element
    public static func buildBlock() -> EmptyBlockElement {
        EmptyBlockElement()
    }

    /// Passes through a single block element unchanged.
    /// - Parameter content: The block element to pass through
    /// - Returns: The same block element
    public static func buildBlock<Content: BlockHTML>(_ content: Content) -> Content {
        content
    }

    /// Handles arrays of block elements in loops.
    /// - Parameter components: Array of block elements
    /// - Returns: A flattened block element
    public static func buildBlock(_ components: [any BlockHTML]) -> some BlockHTML {
        HTMLCollection(components)
    }

    /// Handles array literals in the builder.
    /// - Parameter components: Array of block elements
    /// - Returns: A flattened block element
    public static func buildArray(_ components: [any BlockHTML]) -> some BlockHTML {
        HTMLCollection(components)
    }

    /// Handles optional block elements.
    /// - Parameter component: An optional block element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: BlockHTML>(_ component: Content?) -> some BlockHTML {
        if let component {
            return AnyHTML(component)
        }
        return AnyHTML(EmptyBlockElement())
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The block element to use if condition is true
    /// - Returns: The provided block element
    public static func buildEither<Content: BlockHTML>(first component: Content) -> some BlockHTML {
        component
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The block element to use if condition is false
    /// - Returns: The provided block element
    public static func buildEither<Content: BlockHTML>(second component: Content) -> some BlockHTML {
        component
    }

    /// Handles array transformations in the builder.
    /// - Parameter components: Array of block elements
    /// - Returns: The same array wrapped as a block element
    public static func buildArray<Content: BlockHTML>(_ components: [Content]) -> some BlockHTML {
        components
    }

    /// Handles nested arrays from loops and other control flow.
    /// - Parameter components: Variadic array of block element arrays
    /// - Returns: A flattened block element
    public static func buildBlock(_ components: [any BlockHTML]...) -> some BlockHTML {
        HTMLCollection(components.flatMap { $0 })
    }
}

/// Extension providing result builder functionality for combining multiple HTML elements
extension BlockHTMLBuilder {
    /// Loads a single piece of HTML to be combined with others.
    /// - Parameter content: The HTML to load.
    /// - Returns: The original thing we read, ready to be combined.
    public static func buildPartialBlock<Content>(first content: Content) -> Content where Content: BlockHTML {
        content
    }

    /// Combines an exist piece of HTML with another piece.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildPartialBlock<C0: BlockHTML, C1: BlockHTML>(accumulated: C0, next: C1) -> some BlockHTML {
        if var current = accumulated as? [AnyHTML] {
            current.append(AnyHTML(next))
            return current
        } else {
            return [AnyHTML(accumulated), AnyHTML(next)]
        }
    }
}
