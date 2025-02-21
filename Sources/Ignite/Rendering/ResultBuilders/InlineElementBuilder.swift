//
// InlineElementBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder that enables declarative syntax for constructing inline HTML elements.
///
/// This builder provides support for creating inline element hierarchies using
/// a SwiftUI-like syntax, handling common control flow patterns like conditionals and loops.
@MainActor
@resultBuilder
public struct InlineElementBuilder {
    /// Converts a single inline element into a builder expression.
    /// - Parameter content: The inline element to convert
    /// - Returns: The same inline element, unchanged
    public static func buildExpression<Content: InlineElement>(_ content: Content) -> Content {
        content
    }

    /// Creates an empty HTML element when no content is provided.
    /// - Returns: An empty HTML element
    public static func buildBlock() -> some HTML {
        EmptyHTML()
    }

    /// Passes through a single inline element unchanged.
    /// - Parameter content: The inline element to pass through
    /// - Returns: The same inline element
    public static func buildBlock<Content: InlineElement>(_ content: Content) -> Content {
        content
    }

    /// Handles array transformations in the builder.
    /// - Parameter components: Array of inline elements
    /// - Returns: A flattened HTML element
    public static func buildArray<Content: InlineElement>(_ components: [Content]) -> some HTML {
        HTMLCollection(components)
    }

    /// Handles optional inline elements.
    /// - Parameter component: An optional inline element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: InlineElement>(_ component: Content?) -> some InlineElement {
        if let component {
            AnyHTML(component)
        } else {
            AnyHTML(EmptyHTML())
        }
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The inline element to use if condition is true
    /// - Returns: The provided inline element
    public static func buildEither<Content: InlineElement>(first component: Content) -> Content {
        component
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The inline element to use if condition is false
    /// - Returns: The provided inline element
    public static func buildEither<Content: InlineElement>(second component: Content) -> Content {
        component
    }

    /// Handles variadic inline elements by combining them into a flat structure.
    /// - Parameter components: Variable number of inline elements
    /// - Returns: A flattened HTML structure containing all elements
    public static func buildBlock(_ components: any InlineElement...) -> some InlineElement {
        HTMLCollection(components)
    }
}

/// Extension providing result builder functionality for combining multiple HTML elements
public extension InlineElementBuilder {
    /// Loads a single piece of HTML to be combined with others.
    /// - Parameter content: The HTML to load.
    /// - Returns: The original thing we read, ready to be combined.
    static func buildPartialBlock<Content>(first content: Content) -> Content where Content: InlineElement {
        content
    }

    /// Combines an exist piece of HTML with another piece.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    static func buildPartialBlock<C0: InlineElement, C1: InlineElement>(
        accumulated: C0,
        next: C1
    ) -> some InlineElement {
        if var current = accumulated as? HTMLCollection {
            current.elements.append(next)
            return current
        } else {
            return HTMLCollection([accumulated, next])
        }
    }
}
