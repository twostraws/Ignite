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
public struct BlockElementBuilder {
    /// Converts a single block element into a builder expression.
    /// - Parameter content: The block element to convert
    /// - Returns: The same block element, unchanged
    public static func buildExpression<Content: BlockElement>(_ content: Content) -> Content {
        content
    }

    /// Combines multiple block elements into a single builder expression.
    /// - Parameter content: The block elements to combine
    /// - Returns: A combined block element containing all inputs
    static func buildBlock<Content: BlockElement>(_ content: Content...) -> some BlockElement {
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
    public static func buildBlock<Content: BlockElement>(_ content: Content) -> Content {
        content
    }

    /// Combines two block elements into a single element.
    /// - Parameters:
    ///   - c0: The first block element
    ///   - c1: The second block element
    /// - Returns: A combined block element
    public static func buildBlock<C0: BlockElement, C1: BlockElement>(_ c0: C0, _ c1: C1) -> some BlockElement {
        [AnyHTML(c0), AnyHTML(c1)]
    }

    /// Combines three block elements into a single element.
    /// - Parameters:
    ///   - c0: The first block element
    ///   - c1: The second block element
    ///   - c2: The third block element
    /// - Returns: A combined block element
    public static func buildBlock<C0: BlockElement, C1: BlockElement, C2: BlockElement>(_ c0: C0, _ c1: C1, _ c2: C2) -> some BlockElement {
        [AnyHTML(c0), AnyHTML(c1), AnyHTML(c2)]
    }

    /// Handles arrays of block elements in loops.
    /// - Parameter components: Array of block elements
    /// - Returns: A flattened block element
    public static func buildBlock(_ components: [any BlockElement]) -> some BlockElement {
        FlatHTML(components)
    }

    /// Handles array literals in the builder.
    /// - Parameter components: Array of block elements
    /// - Returns: A flattened block element
    public static func buildArray(_ components: [any BlockElement]) -> some BlockElement {
        FlatHTML(components)
    }

    /// Handles optional block elements.
    /// - Parameter component: An optional block element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: BlockElement>(_ component: Content?) -> some BlockElement {
        if let component {
            return AnyHTML(component)
        }
        return AnyHTML(EmptyBlockElement())
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The block element to use if condition is true
    /// - Returns: The provided block element
    public static func buildEither<Content: BlockElement>(first component: Content) -> some BlockElement {
        component
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The block element to use if condition is false
    /// - Returns: The provided block element
    public static func buildEither<Content: BlockElement>(second component: Content) -> some BlockElement {
        component
    }

    /// Handles array transformations in the builder.
    /// - Parameter components: Array of block elements
    /// - Returns: The same array wrapped as a block element
    public static func buildArray<Content: BlockElement>(_ components: [Content]) -> some BlockElement {
        components
    }

    /// Handles nested arrays from loops and other control flow.
    /// - Parameter components: Variadic array of block element arrays
    /// - Returns: A flattened block element
    public static func buildBlock(_ components: [any BlockElement]...) -> some BlockElement {
        FlatHTML(components.flatMap { $0 })
    }
}
