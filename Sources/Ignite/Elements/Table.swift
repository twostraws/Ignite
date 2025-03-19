//
// Table.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Used to create tabulated data on a page.
public struct Table: HTML {
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

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// What text to use for an optional filter text field.
    var filterTitle: String?

    /// The rows that are inside this table.
    var rows: HTMLCollection

    /// An optional array of header to use at the top of this table.
    var header: HTMLCollection?

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
    /// - Parameters:
    ///   - filterTitle: When provided, this is used to for the placeholder in a
    ///     text field that filters the table data.
    ///   - rows: An array of rows to use in the table.
    public init(
        filterTitle: String? = nil,
        @ElementBuilder<Row> rows: () -> [Row]
    ) {
        self.filterTitle = filterTitle
        self.rows = HTMLCollection(rows())
    }

    /// Creates a new `Table` instance from an element builder that returns
    /// an array of rows to use in the table, and also a page element builder
    /// that returns an array of headers to use at the top of the table.
    /// - Parameters:
    ///   - filterTitle: When provided, this is used to for the placeholder in a
    ///     text field that filters the table data.
    ///   - rows: An array of rows to use in the table.
    ///   - header: An array of headers to use at the top of the table.
    public init(
        filterTitle: String? = nil,
        @ElementBuilder<Row> rows: () -> [Row],
        @HTMLBuilder header: () -> some HTML
    ) {
        self.filterTitle = filterTitle
        self.rows = HTMLCollection(rows())
        self.header = HTMLCollection(header)
    }

    /// Creates a new `Table` instance from a collection of items, along with a function
    /// that converts a single object from the collection into one row in the table.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into rows.
    ///   - filterTitle: When provided, this is used to for the placeholder in a
    ///     text field that filters the table data.
    ///   - content: A function that accepts a single value from the sequence, and
    /// returns a row representing that value in the table.
    public init<T>(
        _ items: any Sequence<T>,
        filterTitle: String? = nil,
        content: (T) -> Row
    ) {
        self.filterTitle = filterTitle
        self.rows = HTMLCollection(items.map(content))
    }

    /// Creates a new `Table` instance from a collection of items, along with a function
    /// that converts a single object from the collection into one row in the table.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into rows.
    ///   - filterTitle: When provided, this is used to for the placeholder in a
    ///     text field that filters the table data.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns a row representing that value in the table.
    ///   - header: An array of headers to use at the top of the table.
    public init<T>(
        _ items: any Sequence<T>,
        filterTitle: String? = nil,
        content: (T) -> Row,
        @HTMLBuilder header: () -> some HTML
    ) {
        self.filterTitle = filterTitle
        self.rows = HTMLCollection(items.map(content))
        self.header = HTMLCollection(header)
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
    /// - Returns: The HTML for this element.
    public func render() -> String {
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

        var output = ""

        if let filterTitle {
            tableAttributes.id = "table-\(UUID().uuidString.truncatedHash)"
            output += """
            <input class=\"form-control mb-2\" type=\"text\" \
            placeholder=\"\(filterTitle)\" \
            onkeyup=\"igniteFilterTable(this.value, '\(tableAttributes.id)')\">
            """
        }

        output += "<table\(tableAttributes)>"

        if let caption {
            output += "<caption>\(caption)</caption>"
        }

        if let header {
            let headerHTML = header.map {
                "<th>\($0.render())</th>"
            }.joined()

            output += "<thead><tr>\(headerHTML)</tr></thead>"
        }

        output += "<tbody>"
        output += rows.render()
        output += "</tbody>"
        output += "</table>"
        return output
    }
}
