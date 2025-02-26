//
// EmptyHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A placeholder HTML element that renders nothing
/// Used as a default or fallback when no content is needed
public struct EmptyHTML: HTML, InlineElement, DocumentElement {
    /// Creates a new empty HTML element
    public nonisolated init() {}

    /// Returns self as the body content since this is an empty element
    public var body: some HTML { self }

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Renders this element as an empty string
    /// - Returns: An empty string
    public func render() -> String {
        ""
    }
}
