//
// AnyHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type-erasing wrapper that can hold any HTML content while maintaining protocol conformance.
/// This wrapper also handles unwrapping nested AnyHTML instances to prevent unnecessary wrapping layers.
public struct AnyHTML: HTML, BlockHTML, InlineElement {
    /// The body of this HTML element, which is itself
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The column width for this element when used in a grid layout
    public var columnWidth: ColumnWidth = .automatic

    /// The underlying HTML content, unwrapped to its most basic form
    let wrapped: any HTML

    /// Creates a new AnyHTML instance that wraps the given HTML content.
    /// If the content is already an AnyHTML instance, it will be unwrapped to prevent nesting.
    /// - Parameter content: The HTML content to wrap
    public init(_ content: any HTML) {
        // Recursively unwrap nested AnyHTML instances
        var current = content
        while let anyHTML = current as? AnyHTML {
            current = anyHTML.wrapped
        }
        self.wrapped = current

        if let content = wrapped as? (any BlockHTML) {
            self.columnWidth = content.columnWidth
        }
    }

    /// Renders the wrapped HTML content using the given publishing context
    /// - Returns: The rendered HTML string
    public func render() -> String {
        AttributeStore.default.merge(attributes, intoHTML: wrapped.id)
        return wrapped.render()
    }
}
