//
// HTMLBuilder.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A result builder that enables declarative syntax for constructing HTML elements.
///
/// This builder provides support for creating HTML hierarchies using SwiftUI-like syntax,
/// handling common control flow patterns like conditionals, loops, and switch statements.
@MainActor
@resultBuilder
public struct HTMLBuilder {
    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression<Content: BodyElement>(_ content: Content) -> some HTML {
        AnyHTML(content)
    }
    
    /// Converts `Never` into a builder expression.
    public static func buildExpression(_ content: Never) -> Never {}

    /// Creates an empty HTML element when no content is provided.
    /// - Returns: An empty HTML element
    public static func buildBlock() -> some HTML {
        AnyHTML(EmptyHTML())
    }
    
    /// Passes through `Never` unchanged.
    public static func buildBlock(_ content: Never) -> Never {}

    /// Passes through a single HTML element unchanged.
    /// - Parameter content: The HTML element to pass through
    /// - Returns: The same HTML element
    public static func buildBlock<Content: BodyElement>(_ content: Content) -> some HTML {
        AnyHTML(content)
    }

    /// Handles optional HTML elements.
    /// - Parameter component: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: BodyElement>(_ component: Content?) -> some HTML {
        if let component {
            AnyHTML(component)
        } else {
            AnyHTML(EmptyHTML())
        }
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is true
    /// - Returns: The wrapped HTML element
    public static func buildEither<Content: BodyElement>(first component: Content) -> AnyHTML {
        AnyHTML(component)
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is false
    /// - Returns: The wrapped HTML element
    public static func buildEither<Content: BodyElement>(second component: Content) -> AnyHTML {
        AnyHTML(component)
    }

    /// Handles availability conditions in switch statements.
    /// - Parameter component: The HTML element to conditionally include
    /// - Returns: The same HTML element unchanged
    public static func buildLimitedAvailability(_ component: some BodyElement) -> some HTML {
        AnyHTML(component)
    }

    /// Handles optional content in if let statements.
    /// - Parameter content: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildBlock<Content: BodyElement>(_ content: Content?) -> some HTML {
        if let content {
            AnyHTML(content)
        } else {
            AnyHTML(EmptyHTML())
        }
    }

    /// Handles multiple optional conditions in nested if let statements.
    /// - Parameter components: Variadic array of optional HTML elements
    /// - Returns: A flattened HTML structure containing non-nil elements
    public static func buildBlock<Content: BodyElement>(_ components: (any HTML)?...) -> some HTML {
        HTMLCollection(components.compactMap(\.self))
    }
}

/// Extension providing result builder functionality for combining multiple HTML elements
extension HTMLBuilder {
    /// Loads a single piece of HTML to be combined with others.
    /// - Parameter content: The HTML to load.
    /// - Returns: The original thing we read, ready to be combined.
    public static func buildPartialBlock<Content>(first content: Content) -> AnyHTML where Content: HTML {
        AnyHTML(content)
    }

    /// Combines an exist piece of HTML with another piece.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildPartialBlock
    <C0: HTML, C1: HTML>(
        accumulated: C0,
        next: C1
    ) -> some HTML {
        if var current = accumulated as? HTMLCollection {
            current.elements.append(next)
            return current
        } else {
            return HTMLCollection([accumulated, next])
        }
    }
}
