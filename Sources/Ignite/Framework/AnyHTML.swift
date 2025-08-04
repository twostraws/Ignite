//
// AnyHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type-erasing wrapper that can hold any `HTML` content while maintaining protocol conformance.
/// This wrapper also handles unwrapping nested `AnyHTML` instances to prevent unnecessary wrapping layers.
public struct AnyHTML: HTML {
    /// The body of this HTML element, which is itself
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: any HTML

    /// Creates a new `AnyHTML` instance that wraps the given HTML content.
    /// - Parameter content: The HTML content to wrap
    public init(_ wrapped: any HTML) {
        var content = wrapped
        attributes.merge(content.attributes)
        content.attributes.clear()
        self.content = content
    }

    /// The underlying HTML content, with attributes.
    var wrapped: any HTML {
        var wrapped = content
        wrapped.attributes.merge(attributes)
        return wrapped
    }

    /// Renders the wrapped HTML content using the given publishing context
    /// - Returns: The rendered HTML string
    public func render() -> Markup {
        wrapped.render()
    }
}
