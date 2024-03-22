//
// Row.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One row inside a `Table`.
public struct Row: PageElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The columns to display inside this row.
    var columns: [PageElement]

    /// Create a new `Row` using a page element builder that returns the
    /// array of columns to use in this row.
    /// - Parameter columns: The columns to use in this row.
    public init(@PageElementBuilder columns: () -> [PageElement]) {
        self.columns = columns()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        let output = columns.map { column in
            if column is Column {
                column.render(context: context)
            } else {
                "<td>\(column.render(context: context))</td>"
            }
        }.joined()

        return "<tr\(attributes.description)>\(output)</tr>"
    }
}
