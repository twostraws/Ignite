//
// Column.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A column inside a table row.
public struct Column: HTML, HorizontalAligning {
    /// How to vertically align the contents of this column.
    public enum VerticalAlignment: String {
        /// Align contents to the top of the column.
        case top

        /// Align contents to the middle of the column.
        case middle

        /// Align contents to the bottom of the column.
        case bottom
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    var columnSpan = 1

    /// How the contents of this column should be vertically aligned.
    /// Defaults to `.top`.
    var verticalAlignment = VerticalAlignment.top

    /// The items to render inside this column.
    var items: [any HTML]

    /// Creates a new column from a page element builder of items.
    /// - Parameter items: A page element builder that returns the items
    /// for this column.
    public init(@HTMLBuilder items: () -> [any HTML]) {
        self.items = items()
    }

    /// Adjusts how many columns in a row this column should span.
    /// - Parameter span: The number of columns to span
    /// - Returns: A new `Column` instance with the updated column span.
    public func columnSpan(_ span: Int) -> Self {
        var copy = self
        copy.columnSpan = span
        return copy
    }

    /// Adjusts the vertical alignment of this carousel.
    /// - Parameter alignment: The new style.
    /// - Returns: A new `Column` instance with the updated vertical alignment.
    public func verticalAlignment(_ alignment: VerticalAlignment) -> Self {
        var copy = self
        copy.verticalAlignment = alignment
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var columnAttributes = attributes

        if verticalAlignment != .top {
            columnAttributes.append(classes: ["align-\(verticalAlignment.rawValue)"])
        }
        columnAttributes.tag = "td colspan=\"\(columnSpan)\""
        columnAttributes.closingTag = "td"
        return columnAttributes.description(wrapping: HTMLCollection(items).render(context: context))
    }
}
