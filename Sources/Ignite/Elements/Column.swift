//
// Column.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A column inside a table row.
public struct Column<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a grid.
    private var columnSpan = 1

    /// How the contents of this column should be vertically aligned.
    /// Defaults to `.top`.
    private var verticalAlignment = ColumnVerticalAlignment.top

    /// The items to render inside this column.
    private var content: Content

    /// Creates a new column from a page element builder of items.
    /// - Parameter items: A page element builder that returns the items
    /// for this column.
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
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
    public func verticalAlignment(_ alignment: ColumnVerticalAlignment) -> Self {
        var copy = self
        copy.verticalAlignment = alignment
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        var columnAttributes = attributes

        if verticalAlignment != .top {
            columnAttributes.append(classes: ["align-\(verticalAlignment.rawValue)"])
        }
        columnAttributes.append(customAttributes: .init(name: "colspan", value: columnSpan.formatted()))
        let contentHTML = content.markupString()
        return Markup("<td\(columnAttributes)>\(contentHTML)</td>")
    }
}

extension Column: ColumnProvider {}
