//
// CarouselElementBuilder.swift
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
public struct CarouselElementBuilder {
    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression<Content: CarouselElement>(_ content: Content) -> Content {
        content
    }

    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildBlock<Content: CarouselElement>(_ content: Content) -> Content {
        content
    }

    /// Combines multiple pieces of HTML together.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildBlock<each Content: CarouselElement>(
        _ content: repeat each Content
    ) -> some CarouselElement {
        PackHTML(repeat each content)
    }
}

/// An HTML representation of the content of a Carousel.
public extension CarouselElementBuilder {
    struct Content<C>: CarouselElement where C: HTML {
        init(content: C) {
            self.content = content
        }
        public var attributes = CoreAttributes()
        public var body: Never { fatalError() }

        var content: C

        public func render() -> Markup {
            content.render()
        }
    }
}
