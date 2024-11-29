//
// InlineElementBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A result builder that enables declarative syntax for constructing inline HTML elements.
///
/// This builder provides support for creating inline element hierarchies using
/// a SwiftUI-like syntax, handling common control flow patterns like conditionals and loops.
@MainActor
@resultBuilder
public struct InlineHTMLBuilder {
    /// Converts a single inline element into a builder expression.
    /// - Parameter content: The inline element to convert
    /// - Returns: The same inline element, unchanged
    public static func buildExpression<Content: InlineHTML>(_ content: Content) -> Content {
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
    public static func buildBlock<Content: InlineHTML>(_ content: Content) -> Content {
        content
    }

    /// Handles array transformations in the builder.
    /// - Parameter components: Array of inline elements
    /// - Returns: A flattened HTML element
    public static func buildArray<Content: InlineHTML>(_ components: [Content]) -> some HTML {
        components.map { AnyHTML($0) }
    }

    /// Handles optional inline elements.
    /// - Parameter component: An optional inline element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: InlineHTML>(_ component: Content?) -> some InlineHTML {
        if let component {
            return AnyHTML(component)
        }
        return AnyHTML(EmptyHTML())
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The inline element to use if condition is true
    /// - Returns: The provided inline element
    public static func buildEither<Content: InlineHTML>(first component: Content) -> Content {
        component
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The inline element to use if condition is false
    /// - Returns: The provided inline element
    public static func buildEither<Content: InlineHTML>(second component: Content) -> Content {
        component
    }

    /// Handles variadic inline elements by combining them into a flat structure.
    /// - Parameter components: Variable number of inline elements
    /// - Returns: A flattened HTML structure containing all elements
    public static func buildBlock(_ components: any InlineHTML...) -> HTMLCollection {
        HTMLCollection(components)
    }
}

/// Extension providing result builder functionality for combining multiple HTML elements
extension InlineHTMLBuilder {
    /// Loads a single piece of HTML to be combined with others.
    /// - Parameter content: The HTML to load.
    /// - Returns: The original thing we read, ready to be combined.
    public static func buildPartialBlock<Content>(first content: Content) -> Content where Content: InlineHTML {
        content
    }

    /// Combines an exist piece of HTML with another piece.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildPartialBlock<C0: InlineHTML, C1: InlineHTML>(accumulated: C0, next: C1) -> some InlineHTML {
        if var current = accumulated as? [AnyHTML] {
            current.append(AnyHTML(next))
            return current
        } else {
            return [AnyHTML(accumulated), AnyHTML(next)]
        }
    }
}
