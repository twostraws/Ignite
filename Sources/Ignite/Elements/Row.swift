//
// Row.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// One row inside a `Table`.
public struct Row<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The columns to display inside this row.
    private var columns: Content

    /// Create a new `Row` using a page element builder that returns the
    /// array of columns to use in this row.
    /// - Parameter columns: The columns to use in this row.
    public init(@HTMLBuilder columns: () -> Content) {
        self.columns = columns()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let output = columns.subviews().map { column in
            if column.wrapped is any ColumnProvider {
                column.render()
            } else {
                Markup("<td>\(column.markupString())</td>")
            }
        }.joined()

        return Markup("<tr\(attributes)>\(output.string)</tr>")
    }
}

extension Row: TableElement {}
