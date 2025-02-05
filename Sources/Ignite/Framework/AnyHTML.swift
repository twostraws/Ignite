//
// AnyHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type-erasing wrapper that can hold any HTML content while maintaining protocol conformance.
/// This wrapper also handles unwrapping nested AnyHTML instances to prevent unnecessary wrapping layers.
public struct AnyHTML: HTML, InlineHTML {
    /// The body of this HTML element, which is itself
    public var body: some HTML { self }

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The underlying HTML content, unwrapped to its most basic form
    private let wrapped: any HTML

    /// Creates a new AnyHTML instance that wraps the given HTML content.
    /// If the content is already an AnyHTML instance, it will be unwrapped to prevent nesting.
    /// - Parameter content: The HTML content to wrap
    public init(_ content: any HTML) {
        // Recursively unwrap nested AnyHTML instances
        if let anyHTML = content as? AnyHTML {
            self.wrapped = anyHTML.unwrapped
        } else {
            self.wrapped = content
        }

        if wrapped.displayType == .block {
            self.columnWidth(wrapped.columnWidth)
        }
    }

    /// Helper property that recursively unwraps nested AnyHTML instances
    /// to get to the underlying content
    var unwrapped: any HTML {
        if let anyHTML = wrapped as? AnyHTML {
            anyHTML.unwrapped
        } else {
            wrapped
        }
    }

    /// Renders the wrapped HTML content using the given publishing context
    /// - Returns: The rendered HTML string
    public func render() -> String {
        wrapped.render()
    }
}
