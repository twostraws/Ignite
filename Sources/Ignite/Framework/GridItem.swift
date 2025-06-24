//
// GridItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An opaque container that wraps HTML content for use within grid layouts.
struct GridItem: HTML {
    /// The content and behavior of this HTML.
    var body: Never { fatalError() }

    /// The HTML content wrapped by this grid item.
    private var content: any HTML

    /// A Boolean value indicating whether this item spans the full width of its container.
    var isFullWidth = false

    /// The standard set of control attributes for HTML elements.
    var attributes = CoreAttributes()

    /// Creates a grid item with the specified content.
    /// - Parameter content: The HTML content to wrap within this grid item.
    init(_ content: any HTML) {
        self.content = content
    }

    /// Renders the grid item as HTML markup.
    /// - Returns: The rendered HTML markup for this grid item.
    func render() -> Markup {
        content.attributes(attributes).render()
    }

    /// An empty grid cell used as a spacer in grid layouts.
    static var emptyCell: Self {
        GridItem(Section().class("ig-grid-spacer"))
    }
}
