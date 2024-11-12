//
// EmptyHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A placeholder HTML element that renders nothing
/// Used as a default or fallback when no content is needed
public struct EmptyHTML: HTML, InlineElement, HTMLRootElement {
    /// Creates a new empty HTML element
    public init() {}

    /// Returns self as the body content since this is an empty element
    public var body: some HTML { self }

    /// Renders this element as an empty string
    /// - Parameter context: The current publishing context
    /// - Returns: An empty string
    public func render(context: PublishingContext) -> String {
        return ""
    }
}
