//
// TableElementBuilder.swift
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
public struct TableElementBuilder {
    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression<Content: TableElement>(_ content: Content) -> Content {
        content
    }

    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildBlock<Content: TableElement>(_ content: Content) -> Content {
        content
    }

    /// Combines multiple pieces of HTML together.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildBlock<each Content: TableElement>(_ content: repeat each Content) -> some TableElement {
        PackHTML(repeat each content)
    }
}

public extension TableElementBuilder {
    /// An HTML representation of the content of a builder-based table.
    struct Content<C>: HTML where C: TableElement {
        public var body: some HTML { self }
        public var attributes = CoreAttributes()
        private var content: C

        /// Creates content with the specified table element.
        /// - Parameter content: The table element to wrap.
        init(_ content: C) {
            self.content = content
        }

        /// Renders the wrapped table element as HTML markup.
        /// - Returns: The rendered markup for the table element.
        public func render() -> Markup {
            content.render()
        }
    }
}
