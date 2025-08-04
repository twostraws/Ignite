//
// Table.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Used to create tabulated data on a page.
public struct Table<Header: HTML, Rows: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// What text to use for an optional filter text field.
    private var filterTitle: String?

    /// The rows that are inside this table.
    private var rows: Rows

    /// An optional array of header to use at the top of this table.
    private var header: Header

    /// The styling to apply to this table. Defaults to `.plain`.
    private var style = TableStyle.plain

    /// An optional caption for this table. Displayed to the user, but also useful
    /// for screen readers so users can decide if the table is worth reading further.
    private var caption: String?

    /// Whether this table should be drawn with a border or not.
    /// Defaults to false.
    private var hasBorderEnabled = false

    /// Creates a new `Table` instance from an element builder that returns
    /// an array of rows to use in the table.
    /// - Parameters:
    ///   - filterTitle: When provided, this is used to for the placeholder in a
    ///     text field that filters the table data.
    ///   - rows: An array of rows to use in the table.
    public init<C>(
        filterTitle: String? = nil,
        @TableElementBuilder rows: () -> C
    ) where Rows == TableElementBuilder.Content<C>, C: TableElement, Header == EmptyHTML {
        self.filterTitle = filterTitle
        self.header = EmptyHTML()
        self.rows = TableElementBuilder.Content(rows())
    }

    /// Creates a new `Table` instance from an element builder that returns
    /// an array of rows to use in the table, and also a page element builder
    /// that returns an array of headers to use at the top of the table.
    /// - Parameters:
    ///   - filterTitle: When provided, this is used to for the placeholder in a
    ///     text field that filters the table data.
    ///   - rows: An array of rows to use in the table.
    ///   - header: An array of headers to use at the top of the table.
    public init<C>(
        filterTitle: String? = nil,
        @TableElementBuilder rows: () -> C,
        @HTMLBuilder header: () -> Header
    ) where Rows == TableElementBuilder.Content<C>, C: TableElement, Header == EmptyHTML {
        self.filterTitle = filterTitle
        self.rows = TableElementBuilder.Content(rows())
        self.header = header()
    }

    /// Creates a new `Table` instance from a collection of items, along with a function
    /// that converts a single object from the collection into one row in the table.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into rows.
    ///   - filterTitle: When provided, this is used to for the placeholder in a
    ///     text field that filters the table data.
    ///   - content: A function that accepts a single value from the sequence, and
    /// returns a row representing that value in the table.
    public init<C, T, S: Sequence>(
        _ items: S,
        filterTitle: String? = nil,
        @TableElementBuilder rows: @escaping (T) -> C
    ) where
        S.Element == T,
        Header == EmptyHTML,
        Rows == TableElementBuilder.Content<ForEach<[T], C>>,
        C: TableElement
    { // swiftlint:disable:this opening_brace
        self.filterTitle = filterTitle
        let content = ForEach(Array(items), content: rows)
        self.rows = TableElementBuilder.Content(content)
        self.header = EmptyHTML()
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
    public init<C, T, S: Sequence>(
        _ items: S,
        filterTitle: String? = nil,
        @TableElementBuilder rows: @escaping (T) -> C,
        @HTMLBuilder header: () -> Header
    ) where
        S.Element == T,
        Rows == TableElementBuilder.Content<ForEach<Array<T>, C>>,
        C: TableElement
    { // swiftlint:disable:this opening_brace
        self.filterTitle = filterTitle
        let content = ForEach(Array(items), content: rows)
        self.rows = TableElementBuilder.Content(content)
        self.header = header()
    }

    /// Adjusts the style of this table.
    /// - Parameter style: The new style.
    /// - Returns: A new `Table` instance with the updated style.
    public func tableStyle(_ style: TableStyle) -> Self {
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
    public func render() -> Markup {
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

        if header.isEmptyHTML == false {
            let headerHTML = header.subviews().map {
                "<th>\($0.markupString())</th>"
            }.joined()
            output += "<thead><tr>\(headerHTML)</tr></thead>"
        }

        output += "<tbody>"
        output += rows.render().string
        output += "</tbody>"
        output += "</table>"
        return Markup(output)
    }
}
