//
// GridRow.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A horizontal row of content within a grid layout.
public struct GridRow<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The content elements that make up this grid row.
    private var content: Content

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Creates a new grid row with the specified content.
    /// - Parameter content: A closure that returns the HTML content for this row.
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates a new grid row with pre-built content.
    /// - Parameter content: The HTML content for this row.
    init(_ content: Content) {
        self.content = content
    }

    /// Generates the HTML markup for this grid row.
    /// - Returns: The markup representation of this grid row.
    public func render() -> Markup {
        content.attributes(attributes).render()
    }
}

extension GridRow: GridItemProvider {
    func gridItems() -> [GridItem] {
        content.subviews().map { GridItem($0) }
    }
}
