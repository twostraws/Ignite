//
// Table.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Used to create tabulated data on a page.
public struct Table: BlockHTML {
    /// Styling options for tables.
    public enum Style {
        /// All table rows and columns look the same. The default.
        case plain

        /// Applies a "zebra stripe" effect where alternate rows have a
        /// varying color.
        case stripedRows

        /// Applies a "zebra stripe" effect where alternate columns have a
        /// varying color.
        case stripedColumns
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The rows that are inside this table.
    var rows: [Row]

    /// An optional array of header to use at the top of this table.
    var header: [any HTML]?

    /// The styling to apply to this table. Defaults to `.plain`.
    var style = Style.plain

    /// An optional caption for this table. Displayed to the user, but also useful
    /// for screen readers so users can decide if the table is worth reading further.
    var caption: String?

    /// Whether this table should be drawn with a border or not.
    /// Defaults to false.
    var hasBorderEnabled = false

    /// Creates a new `Table` instance from an element builder that returns
    /// an array of rows to use in the table.
    /// - Parameter rows: An array of rows to use in the table.
    public init(@ElementBuilder<Row> rows: () -> [Row]) {
        self.rows = rows()
    }

    /// Creates a new `Table` instance from an element builder that returns
    /// an array of rows to use in the table, and also a page element builder
    /// that returns an array of headers to use at the top of the table.
    /// - Parameters:
    ///   - rows: An array of rows to use in the table.
    ///   - header: An array of headers to use at the top of the table.
    public init(
        @ElementBuilder<Row> rows: () -> [Row],
        @HTMLBuilder header: () -> some HTML
    ) {
        self.rows = rows()
        self.header = flatUnwrap(header())
    }

    /// Adjusts the style of this table.
    /// - Parameter style: The new style.
    /// - Returns: A new `Table` instance with the updated style.
    public func tableStyle(_ style: Style) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    /// Enables or disables border drawing for this table.
    /// - Parameter `isActive`: Whether to enable the border or not.
    /// - Returns: A new `Table` instance with the updated border setting.
    public func tableBorder(_ isActive: Bool) -> Self {
        var copy = self
        copy.hasBorderEnabled = isActive
        return copy
    }

    /// Updates the caption for this table to a different string.
    /// - Parameter label: The new accessibility label.
    /// - Returns: A new `Table` instance with the updated accessibility label.
    public func accessibilityLabel(_ label: String) -> Self {
        var copy = self
        copy.caption = label
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var tableAttributes = attributes.appending(classes: ["table"])

        if hasBorderEnabled {
            tableAttributes.append(classes: ["table-bordered"])
        }

        switch style {
        case .plain:
            break
        case .stripedRows:
            tableAttributes.append(classes: ["table-striped"])
        case .stripedColumns:
            tableAttributes.append(classes: ["table-striped-columns"])
        }

        var output = "<table\(tableAttributes.description())>"

        if let caption {
            output += "<caption>\(caption)</caption>"
        }

        if let header {
            let headerHTML = header.map {
                "<th>\($0.render(context: context))</th>"
            }.joined()

            output += "<thead><tr>\(headerHTML)</tr></thead>"
        }

        output += "<tbody>"
        output += rows.render(context: context)
        output += "</tbody>"
        output += "</table>"
        return output
    }
}
