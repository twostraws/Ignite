//
// InlineElementBuilder.swift
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
public struct InlineElementBuilder {
    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression<Content: InlineElement>(_ content: Content) -> some InlineElement {
        content
    }

    /// Converts `Never` into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression(_ content: Never) -> Never {}

    /// Creates an empty HTML element when no content is provided.
    /// - Returns: An empty HTML element
    public static func buildBlock() -> some InlineElement {
        EmptyInlineElement()
    }

    /// Passes through a single HTML element unchanged.
    /// - Parameter content: The HTML element to pass through
    /// - Returns: The same HTML element
    public static func buildBlock(_ content: Never) -> Never {}

    /// Passes through a single HTML element unchanged.
    /// - Parameter content: The HTML element to pass through
    /// - Returns: The same HTML element
    public static func buildBlock<Content: InlineElement>(_ content: Content) -> some InlineElement {
        content
    }

    /// Handles the first branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is true
    /// - Returns: The wrapped HTML element
    public static func buildEither<T, F>(
        first content: T
    ) -> ConditionalHTML<T, F> where T: InlineElement, F: InlineElement {
        .init(storage: .trueContent(content))
    }

    /// Handles the second branch of an if/else statement.
    /// - Parameter component: The HTML element to use if condition is false
    /// - Returns: The wrapped HTML element
    public static func buildEither<T, F>(
        second content: F
    ) -> ConditionalHTML<T, F> where T: InlineElement, F: InlineElement {
        .init(storage: .falseContent(content))
    }

    /// Handles optional content in if statements.
    /// - Parameter component: An optional HTML element
    /// - Returns: Either the wrapped element or an empty element
    public static func buildOptional<Content: InlineElement>(
        _ content: Content?
    ) -> ConditionalHTML<Content, EmptyInlineElement> {
        guard let content else {
            return buildEither(second: EmptyInlineElement())
        }
        return buildEither(first: content)
    }

    /// Handles availability conditions in switch statements.
    /// - Parameter component: The HTML element to conditionally include
    /// - Returns: The same HTML element unchanged
    public static func buildLimitedAvailability(_ component: some InlineElement) -> some InlineElement {
        AnyInlineElement(component)
    }

    /// Combines multiple pieces of HTML together.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildBlock<each Content>(
        _ content: repeat each Content
    ) -> some InlineElement where repeat each Content: InlineElement {
        PackHTML(repeat each content)
    }
}
