//
// InlineGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A transparent grouping construct that propagates modifiers to its inline children.
///
/// Use `InlineGroup` when you want to apply shared modifiers to multiple inline elements
/// without introducing additional HTML structure. It passes modifiers through
/// to each child element.
///
/// - Note: `InlineGroup` is particularly useful for applying shared styling or
///         attributes to multiple inline elements without affecting the document
///         structure.
public struct InlineGroup<Content: InlineElement>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    private var content: Content

    /// Creates a new group containing the given HTML content.
    /// - Parameter content: A closure that creates the HTML content.
    public init(@InlineElementBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates a new group containing the given HTML content.
    /// - Parameter content: The HTML content to include.
    public init(_ content: Content) {
        self.content = content
    }

    public func render() -> Markup {
        content.attributes(attributes).render()
    }
}
