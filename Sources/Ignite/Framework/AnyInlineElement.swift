//
// AnyInlineElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type-erasing wrapper that can hold any `InlineElement`
/// content while maintaining protocol conformance.
/// This wrapper also handles unwrapping nested `AnyInlineElement`
/// instances to prevent unnecessary wrapping layers.
public struct AnyInlineElement: InlineElement {
    /// The body of this HTML element, which is itself.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    var wrapped: any InlineElement

    /// Creates a new `AnyInlineElement` instance that wraps the given HTML content.
    /// If the content is already an `AnyInlineElement` instance,
    /// it will be unwrapped to prevent nesting.
    /// - Parameter content: The `InlineElement` content to wrap
    public init(_ content: any InlineElement) {
        var content = content
        attributes.merge(content.attributes)
        content.attributes.clear()

        if let anyHTML = content as? AnyInlineElement {
            wrapped = anyHTML.wrapped
        } else {
            wrapped = content
        }
    }

    /// The underlying `InlineElement`, with attributes.
    var attributedContent: any InlineElement {
        var wrapped = wrapped
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    /// Renders the wrapped HTML content using the given publishing context
    /// - Returns: The rendered HTML string
    public func render() -> Markup {
        var wrapped = wrapped
        wrapped.attributes.merge(attributes)
        return wrapped.render()
    }
}
