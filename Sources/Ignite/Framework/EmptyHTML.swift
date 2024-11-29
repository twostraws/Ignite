//
// EmptyHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A placeholder HTML element that renders nothing
/// Used as a default or fallback when no content is needed
public struct EmptyHTML: HTML, InlineHTML, RootHTML {
    /// Creates a new empty HTML element
    public init() {}

    /// Returns self as the body content since this is an empty element
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Renders this element as an empty string
    /// - Parameter context: The current publishing context
    /// - Returns: An empty string
    public func render(context: PublishingContext) -> String {
        ""
    }
}
