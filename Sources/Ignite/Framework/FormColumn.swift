//
// FormColumn.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A form layout container that organizes content within a column-based grid system.
struct FormColumn<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// The content to display within the column.
    var content: Content

    /// The width of the column in grid units.
    var width: Int

    /// Creates a form column with the specified width and content.
    /// - Parameters:
    ///   - width: The column width in grid units.
    ///   - content: The HTML content to display within the column.
    init(width: Int, content: Content) {
        self.content = content
        self.width = width
    }

    /// Creates a form column with the specified width and inline element content.
    /// - Parameters:
    ///   - width: The column width in grid units.
    ///   - content: The inline element content to display within the column.
    init<T: InlineElement>(width: Int, content: T) where Content == InlineHTML<T> {
        self.content = InlineHTML(content)
        self.width = width
    }

    /// Renders the form column as HTML markup.
    /// - Returns: The rendered HTML markup for the column.
    func render() -> Markup {
        Section(content)
            .attributes(attributes)
            .class(ColumnWidth.count(width).className)
            .render()
    }
}

extension FormColumn: FormElementRenderable where Content: FormElementRenderable {
    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup {
        var attributes = attributes
        attributes.append(classes: ColumnWidth.count(width).className)
        let markup = content.renderAsFormElement(configuration)
        return Markup("<div\(attributes)>\(markup.string)</div>")
    }
}
