//
// EmptyBlockElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A placeholder block element that renders nothing
/// Used as a default or fallback when no block content is needed
public struct EmptyBlockElement: BlockElement {
    /// The column width setting for this element when used in a grid layout
    public var columnWidth: ColumnWidth = .automatic

    /// Returns self as the body content since this is an empty element
    public var body: some HTML { self }

    /// Renders this element as an empty string
    /// - Parameter context: The current publishing context
    /// - Returns: An empty string
    public func render(context: PublishingContext) -> String {
        return ""
    }
}
