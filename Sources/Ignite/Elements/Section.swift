//
// Section.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Creates one distinct section on your page, where content inside is fitted to
/// a 12-column grid. If the items in your section have widths that add up to
/// 12 then they will fit in a single row, otherwise they will be placed on multiple
/// rows. This element automatically adapts to constrained horizontal dimensions
/// by placing your content across multiple rows automatically.
///
/// **Note**: A 12-column grid is the default, but you can adjust that downwards
/// by using the `columns()` modifier.
public struct Section: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// How many columns this should be divided into
    var columnCount: Int?

    /// The items to display in this section.
    private var items: [any HTML]

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameter items: The items to use in this section.
    public init(@HTMLBuilder items: () -> some HTML) {
        self.items = flatUnwrap(items())
    }

    /// Adjusts the number of columns that can be fitted into this section.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Section` instance with the updated column count.
    public func columns(_ columns: Int) -> Self {
        var copy = self
        copy.columnCount = columns
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var sectionAttributes = attributes.appending(classes: ["row"])

        // If a column count is set, we want to use that for all
        // page sizes that are medium and above. Below that we
        // should drop down to width 1 to avoid squeezing things
        // into oblivion.
        if let columnCount {
            sectionAttributes.append(classes: [
                "row-cols-1",
                "row-cols-md-\(columnCount)",
            ])
        }

        return Group {
            ForEach(items) { item in
                if let item = item as? any BlockHTML {
                    Group(item)
                        .class(item.columnWidth.className)
                } else {
                    item
                }
            }
        }
        .attributes(sectionAttributes)
        .render(context: context)
    }
}
