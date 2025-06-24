//
// DropdownElementBuilder.swift
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
public struct DropdownElementBuilder {
    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildExpression<Content: DropdownElement>(_ content: Content) -> Content {
        content
    }

    /// Converts a single HTML element into a builder expression.
    /// - Parameter content: The HTML element to convert
    /// - Returns: The same HTML element, unchanged
    public static func buildBlock<Content: DropdownElement>(_ content: Content) -> Content {
        content
    }

    /// Combines multiple pieces of HTML together.
    /// - Parameters:
    ///   - accumulated: The previous collection of HTML.
    ///   - next: The next piece of HTML to combine.
    /// - Returns: The combined HTML.
    public static func buildBlock<each Content: DropdownElement>(
        _ content: repeat each Content
    ) -> some DropdownElement {
        PackHTML(repeat each content)
    }
}

/// An HTML representation of the content of a Dropdown.
public extension DropdownElementBuilder {
    struct Content<C>: HTML where C: DropdownElement {
        public var body: some HTML { self }
        public var attributes = CoreAttributes()
        private var content: C

        init(_ content: C) {
            self.content = content
        }

        public func render() -> Markup {
            var content = content
            content.attributes.merge(attributes)

            return if let content = content as? any DropdownElementRenderable {
                content.renderAsDropdownElement()
            } else {
                content.render()
            }
        }
    }
}
