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
public struct RenderableElementBuilder {
    /// Converts a single HTML element into a builder expression.
    public static func buildExpression<Content: HTML>(_ content: Content) -> some RenderableElement {
        content
    }

    /// Converts a single InlineElement into a builder expression.
    public static func buildExpression<Content: InlineElement>(_ content: Content) -> some RenderableElement {
        content
    }

    /// Creates an empty HTML element when no content is provided.
    public static func buildBlock() -> some RenderableElement {
        EmptyHTML()
    }

    /// Passes through a single element unchanged.
    public static func buildBlock<Content: RenderableElement>(_ content: Content) -> some RenderableElement {
        content
    }

    /// Combines an array of elements into a flat structure.
    public static func buildBlock(_ components: [any RenderableElement]) -> some RenderableElement {
        HTMLCollection(components)
    }

    /// Handles array literals in the builder.
    public static func buildArray(_ components: [any RenderableElement]) -> some RenderableElement {
        HTMLCollection(components)
    }

    /// Handles optional elements.
    public static func buildOptional<Content: RenderableElement>(_ component: Content?) -> some RenderableElement {
        if let component {
            AnyHTML(component)
        } else {
            AnyHTML(EmptyHTML())
        }
    }

    /// Handles the first branch of an if/else statement.
    public static func buildEither<Content: RenderableElement>(first component: Content) -> AnyHTML {
        AnyHTML(component)
    }

    /// Handles the second branch of an if/else statement.
    public static func buildEither<Content: RenderableElement>(second component: Content) -> AnyHTML {
        AnyHTML(component)
    }

    /// Handles optional content in if statements.
    public static func buildIf<Content: RenderableElement>(_ component: Content?) -> some RenderableElement {
        if let component {
            AnyHTML(component)
        } else {
            AnyHTML(EmptyHTML())
        }
    }

    /// Handles array transformations in the builder.
    public static func buildArray<Content: RenderableElement>(_ components: [Content]) -> some RenderableElement {
        HTMLCollection(components)
    }

    /// Handles nested arrays from loops and other control flow.
    public static func buildBlock(_ components: [any RenderableElement]...) -> some RenderableElement {
        HTMLCollection(components.flatMap(\.self))
    }

    /// Converts text content into HTML.
    public static func buildExpression(_ text: Text) -> some RenderableElement {
        text
    }

    /// Handles availability conditions in switch statements.
    public static func buildLimitedAvailability(_ component: some RenderableElement) -> some RenderableElement {
        component
    }

    /// Handles nested arrays of elements.
    public static func buildArray(_ components: [[any RenderableElement]]) -> some RenderableElement {
        HTMLCollection(components.flatMap(\.self))
    }

    /// Handles optional content in if let statements.
    public static func buildBlock<Content: RenderableElement>(_ content: Content?) -> some RenderableElement {
        if let content {
            AnyHTML(content)
        } else {
            AnyHTML(EmptyHTML())
        }
    }
}

/// Extension providing result builder functionality for combining multiple elements
extension RenderableElementBuilder {
    /// Loads a single element to be combined with others.
    public static func buildPartialBlock<Content: RenderableElement>(first content: Content) -> Content {
        content
    }

    /// Combines an existing element with another element.
    public static func buildPartialBlock<C0: RenderableElement, C1: RenderableElement>(
        accumulated: C0,
        next: C1
    ) -> some RenderableElement {
        if var current = accumulated as? HTMLCollection {
            current.elements.append(next)
            return current
        } else {
            return HTMLCollection([accumulated, next])
        }
    }
}
