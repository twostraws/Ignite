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
    public static func buildExpression<Content: HTML>(_ content: Content) -> some HTML {
        content
    }

    /// Converts `Never` into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression(_ content: Never) -> Never {}

    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression<Content: InlineElement>(_ content: Content) -> some HTML {
        InlineHTML(content)
    }

    /// Creates an empty HTML element when no content is provided.
    /// - Returns: An empty HTML element
    public static func buildBlock() -> some HTML {
        EmptyHTML()
    }

    /// Passes through a single HTML element unchanged.
    /// - Parameter content: The HTML element to pass through
    /// - Returns: The same HTML element
    public static func buildBlock(_ content: Never) -> Never {}

    /// Passes through a single HTML element unchanged.
    /// - Parameter content: The HTML element to pass through
    /// - Returns: The same HTML element
    public static func buildBlock<Content: HTML>(_ content: Content) -> some HTML {
        content
    }

    /// Passes through a single HTML element unchanged.
    /// - Parameter content: The HTML element to pass through
    /// - Returns: The same HTML element
    public static func buildBlock<Content: InlineElement>(_ content: Content) -> some HTML {
        InlineHTML(content)
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is true
    /// - Returns: The wrapped HTML element
    public static func buildEither<TrueContent, FalseContent>(
        first content: TrueContent
    ) -> ConditionalHTML<TrueContent, FalseContent> where TrueContent: HTML, FalseContent: HTML {
        .init(storage: .trueContent(content))
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is true
    /// - Returns: The wrapped HTML element
    public static func buildEither<TrueContent, FalseContent>(
        first content: TrueContent
    ) -> ConditionalHTML<InlineHTML<TrueContent>, FalseContent> where TrueContent: InlineElement, FalseContent: HTML {
        .init(storage: .trueContent(InlineHTML(content)))
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is false
    /// - Returns: The wrapped HTML element
    public static func buildEither<TrueContent, FalseContent>(
        second content: FalseContent
    ) -> ConditionalHTML<TrueContent, FalseContent> where TrueContent: HTML, FalseContent: HTML {
        .init(storage: .falseContent(content))
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is false
    /// - Returns: The wrapped HTML element
    public static func buildEither<TrueContent, FalseContent>(
        second content: FalseContent
    ) -> ConditionalHTML<TrueContent, InlineHTML<FalseContent>> where TrueContent: HTML, FalseContent: InlineElement {
        .init(storage: .falseContent(InlineHTML(content)))
    }

    /// Handles optional content in if statements.
    /// - Parameter component: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: HTML>(_ content: Content?) -> ConditionalHTML<Content, EmptyHTML> {
        guard let content else {
            return buildEither(second: EmptyHTML())
        }
        return buildEither(first: content)
    }

    /// Handles optional content in if statements.
    /// - Parameter component: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: InlineElement>(
        _ content: Content?
    ) -> ConditionalHTML<InlineHTML<Content>, EmptyHTML> {
        guard let content else {
            return buildEither(second: EmptyHTML())
        }
        return buildEither(first: InlineHTML(content))
    }

    /// Handles availability conditions in switch statements.
    /// - Parameter component: The HTML element to conditionally include
    /// - Returns: The same HTML element unchanged
    public static func buildLimitedAvailability(_ component: some HTML) -> some HTML {
        AnyHTML(component)
    }

    /// Combines multiple pieces of HTML together.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> some HTML where repeat each Content: HTML {
        PackHTML(repeat each content)
    }
}
