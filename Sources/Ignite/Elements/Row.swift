//
// Row.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// One row inside a `Table`.
public struct Row: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The columns to display inside this row.
    private var columns: [any HTML]

    /// Create a new `Row` using a page element builder that returns the
    /// array of columns to use in this row.
    /// - Parameter columns: The columns to use in this row.
    public init(@HTMLBuilder columns: () -> some HTML) {
        self.columns = flatUnwrap(columns())
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        let output = columns.map { column in
            if column is Column {
                column.render()
            } else {
                "<td>\(column.render())</td>"
            }
        }.joined()
        var attributes = attributes
        attributes.tag = "tr"
        return attributes.description(wrapping: output)
    }
}
