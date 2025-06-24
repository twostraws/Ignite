//
// Grid.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates a 12-column grid. If the items in your grid have widths that add up to
/// 12 then they will fit in a single row, otherwise they will be placed on multiple
/// rows. This element automatically adapts to constrained horizontal dimensions
/// by placing your content across multiple rows automatically.
///
/// **Note**: A 12-column grid is the default, but you can adjust that downwards
/// by using the `columns()` modifier.
public struct Grid<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The amount of space between elements.
    private var spacingAmount: SpacingAmount

    /// The alignment of the items within the grid.
    private var alignment: Alignment

    /// How grid items should size.
    private var gridItemSizing: GridItemSizing = .automatic

    /// The number of columns this grid should span. Use `nil` to have
    /// the column count based on the longest row.
    private var columnCount: Int?

    /// The rows that make up the grid's content.
    private var content: Content

    /// Creates a new `Grid` object using a block element builder
    /// that returns an array of items to use in this grid.
    /// - Parameters:
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The number of pixels between each element.
    ///   - items: The items to use in this grid.
    public init(
        columns: Int? = nil,
        alignment: Alignment = .center,
        spacing: Int,
        @HTMLBuilder content: () -> Content
    ) {
        self.spacingAmount = .exact(spacing)
        self.alignment = alignment
        self.columnCount = columns
        self.content = content()
    }

    /// Creates a new `Grid` object using a block element builder
    /// that returns an array of items to use in this grid.
    /// - Parameters:
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The predefined size between each element. Defaults to `.none`.
    ///   - items: The items to use in this grid.
    public init(
        columns: Int? = nil,
        alignment: Alignment = .center,
        spacing: SemanticSpacing = .medium,
        @HTMLBuilder content: () -> Content
    ) {
        self.spacingAmount = .semantic(spacing)
        self.alignment = alignment
        self.columnCount = columns
        self.content = content()
    }

    /// Creates a new grid from a collection of items, along with a function that converts
    /// a single object from the collection into one grid column.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into columns.
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The number of pixels between each element.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns some HTML representing that value in the grid.
    public init<T, S: Sequence, ItemContent: HTML>(
        _ items: S,
        columns: Int? = nil,
        alignment: Alignment = .center,
        spacing: Int,
        @HTMLBuilder content: @escaping (T) -> ItemContent
    ) where S.Element == T, Content == ForEach<[T], ItemContent> {
        self.spacingAmount = .exact(spacing)
        self.alignment = alignment
        self.columnCount = columns
        let content = ForEach(Array(items), content: content)
        self.content = content
    }

    /// Creates a new grid from a collection of items, along with a function that converts
    /// a single object from the collection into one grid column.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into columns.
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The predefined size between each element. Defaults to `.none`
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns some HTML representing that value in the grid.
    public init<T, S: Sequence, ItemContent: HTML>(
        _ items: S,
        columns: Int? = nil,
        alignment: Alignment = .center,
        spacing: SemanticSpacing = .medium,
        @HTMLBuilder content: @escaping (T) -> ItemContent
    ) where S.Element == T, Content == ForEach<[T], ItemContent> {
        self.spacingAmount = .semantic(spacing)
        self.alignment = alignment
        self.columnCount = columns
        let content = ForEach(Array(items), content: content)
        self.content = content
    }

    /// Controls how grid items size and expand within the grid.
    /// - Parameter sizing: The sizing behavior to apply to grid items.
    /// - Returns: A modified copy of this grid with the updated sizing behavior.
    public func gridItemSizing(_ sizing: GridItemSizing) -> Self {
        var copy = self
        copy.gridItemSizing = sizing
        return copy
    }

    private func createGridAttributes(columnCount: Int) -> CoreAttributes {
        var attributes = attributes
        attributes.append(styles: gridItemSizing.inlineStyles)
        attributes.append(styles:
            .init("--ig-grid-columns", value: columnCount.formatted()),
            .init("--ig-grid-gap", value: "20px")
        )
        return attributes
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let subviews = content.subviews()
        let (flattenedGridItems, columnCount) = processGridItems(subviews)
        let attributes = createGridAttributes(columnCount: columnCount)

        return Section {
            ForEach(flattenedGridItems) { child in
                child
                    .class("ig-grid-item")
            }
        }
        .attributes(attributes)
        .class("ig-adaptive-grid")
        .style(spacingAmount.inlineStyle)
        .style(alignment.gridAlignmentRules)
        .render()
    }
}

private extension Grid {
    /// Processes child views into grid items and returns flattened items with column count.
    /// - Parameter children: Collection of subviews to process into grid items
    /// - Returns: A tuple containing flattened grid items and column count as a string
    func processGridItems(_ children: SubviewsCollection) -> ([GridItem], Int) {
        let gridItems = children.map { $0.resolvedToGridItems() }

        if areAllItemsFullWidth(gridItems) {
            return processFullWidthItems(gridItems)
        }

        let maxColumnCount = columnCount ?? gridItems.map(\.count).max() ?? 1

        let flattenedItems = gridItems
            .map { padRow($0, maxColumnCount: maxColumnCount) }
            .flatMap(\.self)

        return (flattenedItems, maxColumnCount)
    }

    /// Determines if all grid items are full-width items.
    /// - Parameter gridItems: 2D array of grid items to check
    /// - Returns: `true` if all items are full width, `false` otherwise
    func areAllItemsFullWidth(_ gridItems: [[GridItem]]) -> Bool {
        gridItems.allSatisfy { row in
            row.count == 1 && row.first?.isFullWidth == true
        }
    }

    /// Pads a row of grid items to match the maximum column count.
    /// - Parameters:
    ///   - row: Array of grid items representing a row
    ///   - maxColumnCount: Maximum number of columns in the grid
    /// - Returns: Padded array of grid items
    func padRow(_ row: [GridItem], maxColumnCount: Int) -> [GridItem] {
        if row.count == 1 && row.first?.isFullWidth == true {
            guard var item = row.first, columnCount != nil else { return row }
            item.attributes.append(styles: .init(.gridColumn, value: "span \(maxColumnCount)"))
            return [item]
        }

        let emptyCellsNeeded = maxColumnCount - row.count
        return emptyCellsNeeded > 0 ? row + Array(repeating: .emptyCell, count: emptyCellsNeeded) : row
    }

    /// Processes grid items that are all full-width.
    /// - Parameter gridItems: 2D array of grid items to process
    /// - Returns: A tuple containing flattened grid items and column count as a string
    func processFullWidthItems(_ gridItems: [[GridItem]]) -> ([GridItem], Int) {
        var items = gridItems.flatMap(\.self)
        items = items.map {
            var item = $0
            item.attributes.append(classes: "ig-full-width-grid-item")
            return item
        }
        return (items, columnCount ?? 12)
    }
}
