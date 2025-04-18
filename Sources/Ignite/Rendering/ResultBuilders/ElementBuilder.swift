//
//  ElementBuilder.swift
//  Ignite
//
//  Created by Joshua Toro on 4/18/25.
//

/// A result builder that enables declarative syntax for constructing HTML elements.
///
/// This builder provides support for creating HTML hierarchies using SwiftUI-like syntax,
/// handling common control flow patterns like conditionals, loops, and switch statements.
@MainActor
@resultBuilder
public struct ElementBuilder {
    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression<Content: Element>(_ content: Content) -> some Element {
        content
    }

    /// Creates an empty HTML element when no content is provided.
    /// - Returns: An empty HTML element
    public static func buildBlock() -> some Element {
        EmptyHTML()
    }

    /// Passes through a single HTML element unchanged.
    /// - Parameter content: The HTML element to pass through
    /// - Returns: The same HTML element
    public static func buildBlock<Content: Element>(_ content: Content) -> some Element {
        content
    }

    /// Combines an array of HTML elements into a flat structure.
    /// - Parameter components: Array of HTML elements
    /// - Returns: A flattened HTML structure
    public static func buildBlock(_ components: [any Element]) -> some Element {
        HTMLCollection(components)
    }

    /// Handles array literals in the builder.
    /// - Parameter components: Array of HTML elements
    /// - Returns: A flattened HTML structure
    public static func buildArray(_ components: [any Element]) -> some Element {
        HTMLCollection(components)
    }

    /// Handles optional HTML elements.
    /// - Parameter component: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: Element>(_ component: Content?) -> some Element {
        if let component {
            AnyHTML(component)
        } else {
            AnyHTML(EmptyHTML())
        }
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is true
    /// - Returns: The wrapped HTML element
    public static func buildEither<Content: Element>(first component: Content) -> AnyHTML {
        AnyHTML(component)
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is false
    /// - Returns: The wrapped HTML element
    public static func buildEither<Content: Element>(second component: Content) -> AnyHTML {
        AnyHTML(component)
    }

    /// Handles optional content in if statements.
    /// - Parameter component: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildIf<Content: Element>(_ component: Content?) -> AnyHTML {
        if let component {
            AnyHTML(component)
        } else {
            AnyHTML(EmptyHTML())
        }
    }

    /// Handles array transformations in the builder.
    /// - Parameter components: Array of HTML elements
    /// - Returns: The same array as HTML content
    public static func buildArray<Content: Element>(_ components: [Content]) -> some Element {
        HTMLCollection(components)
    }

    /// Handles nested arrays from loops and other control flow.
    /// - Parameter components: Variadic array of HTML element arrays
    /// - Returns: A flattened HTML structure
    public static func buildBlock(_ components: [any Element]...) -> some Element {
        HTMLCollection(components.flatMap(\.self))
    }

    /// Converts text content into HTML.
    /// - Parameter text: The text to convert
    /// - Returns: Text wrapped as HTML
    public static func buildExpression(_ text: Text) -> some Element {
        text
    }

    /// Handles availability conditions in switch statements.
    /// - Parameter component: The HTML element to conditionally include
    /// - Returns: The same HTML element unchanged
    public static func buildLimitedAvailability(_ component: some Element) -> some Element {
        component
    }

    /// Handles nested arrays of HTML elements.
    /// - Parameter components: Two-dimensional array of HTML elements
    /// - Returns: A flattened HTML structure
    public static func buildArray(_ components: [[any Element]]) -> some Element {
        HTMLCollection(components.flatMap(\.self))
    }

    /// Handles optional content in if let statements.
    /// - Parameter content: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildBlock<Content: Element>(_ content: Content?) -> some Element {
        if let content {
            AnyHTML(content)
        } else {
            AnyHTML(EmptyHTML())
        }
    }

    /// Handles multiple optional conditions in nested if let statements.
    /// - Parameter components: Variadic array of optional HTML elements
    /// - Returns: A flattened HTML structure containing non-nil elements
    public static func buildBlock<Content: Element>(_ components: (any Element)?...) -> some Element {
        HTMLCollection(components.compactMap(\.self))
    }
}

/// Extension providing result builder functionality for combining multiple HTML elements
extension HTMLBuilder {
    /// Loads a single piece of HTML to be combined with others.
    /// - Parameter content: The HTML to load.
    /// - Returns: The original thing we read, ready to be combined.
    public static func buildPartialBlock<Content>(first content: Content) -> AnyHTML where Content: Element {
        AnyHTML(content)
    }

    /// Combines an exist piece of HTML with another piece.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildPartialBlock
    <C0: Element, C1: Element>(
        accumulated: C0,
        next: C1
    ) -> some Element {
        if var current = accumulated as? HTMLCollection {
            current.elements.append(next)
            return current
        } else {
            return HTMLCollection([accumulated, next])
        }
    }
}
