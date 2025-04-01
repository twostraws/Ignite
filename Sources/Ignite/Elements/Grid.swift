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
public struct Grid: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should be divided into
    var columnCount: Int?

    /// The amount of space between elements.
    private var spacingAmount: SpacingType = .semantic(.none)

    /// The alignment of the items within the grid.
    private var alignment: Alignment = .center

    /// The items to display in this grid.
    private var items: HTMLCollection

    /// Creates a new `Grid` object using a block element builder
    /// that returns an array of items to use in this grid.
    /// - Parameters:
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The number of pixels between each element.
    ///   - items: The items to use in this grid.
    public init(
        alignment: Alignment = .center,
        spacing: Int,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        self.spacingAmount = .exact(spacing)
    }

    /// Creates a new `Grid` object using a block element builder
    /// that returns an array of items to use in this grid.
    /// - Parameters:
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The predefined size between each element. Defaults to `.none`.
    ///   - items: The items to use in this grid.
    public init(
        alignment: Alignment = .center,
        spacing: SpacingAmount = .medium,
        @HTMLBuilder items: () -> some HTML
    ) {
        self.items = HTMLCollection(items)
        self.alignment = alignment
        self.spacingAmount = .semantic(spacing)
    }

    /// Creates a new grid from a collection of items, along with a function that converts
    /// a single object from the collection into one grid column.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into columns.
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The number of pixels between each element.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns a some HTML representing that value in the grid.
    public init<T>(
        _ items: any Sequence<T>,
        alignment: Alignment = .center,
        spacing: Int, content: (T) -> some HTML
    ) {
        self.items = HTMLCollection(items.map(content))
        self.alignment = alignment
        self.spacingAmount = .exact(spacing)
    }

    /// Creates a new grid from a collection of items, along with a function that converts
    /// a single object from the collection into one grid column.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into columns.
    ///   - alignment: The alignment of items in the grid. Defaults to `.center`.
    ///   - spacing: The predefined size between each element. Defaults to `.none`
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns a some HTML representing that value in the grid.
    public init<T>(
        _ items: any Sequence<T>,
        alignment: Alignment = .center,
        spacing: SpacingAmount = .medium,
        content: (T) -> some HTML
    ) {
        self.items = HTMLCollection(items.map(content))
        self.alignment = alignment
        self.spacingAmount = .semantic(spacing)
    }

    /// Adjusts the number of columns that can be fitted into this grid.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Grid` instance with the updated column count.
    public func columns(_ columns: Int) -> Self {
        var copy = self
        copy.columnCount = columns
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var gridAttributes = attributes.appending(classes: ["row"])
        gridAttributes.append(classes: alignment.horizontal.containerAlignmentClass)

        // If a column count is set, we want to use that for all
        // page sizes that are medium and above. Below that we
        // should drop down to width 1 to avoid squeezing things
        // into oblivion.
        if let columnCount {
            gridAttributes.append(classes: [
                "row-cols-1",
                "row-cols-md-\(columnCount)"
            ])
        }

        var gutterClass = ""

        switch spacingAmount {
        case .exact(let pixels) where pixels != 0:
            gridAttributes.append(styles: .init(.rowGap, value: "\(pixels)px"))
        case .semantic(let amount) where spacingAmount != .semantic(.none):
            gutterClass = "g-\(amount.rawValue)"
        default: break
        }

        return Section {
            ForEach(items) { item in
                if let passthrough = item as? any PassthroughElement {
                    handlePassthrough(passthrough, attributes: passthrough.attributes)
                } else if let modified = item as? AnyHTML,
                          let passthrough = modified.wrapped as? any PassthroughElement {
                    handlePassthrough(passthrough, attributes: modified.attributes)
                } else {
                    handleItem(item)
                        .class(gutterClass)
                        .render()
                }
            }
        }
        .attributes(gridAttributes)
        .render()
    }

    /// Removes a column class, if it exists, from the item and reassigns it to a wrapper.
    private func handleItem(_ item: any HTML) -> any HTML {
        var item = item
        var name: String?
        if let widthClass = item.attributes.classes.first(where: { $0.starts(with: "col-md-") }) {
            item.attributes.remove(classes: widthClass)
            name = scaleWidthClass(widthClass)
        }

        item = item.isSection ? item : Section(item)

        return item
            .class(name ?? "col")
            .class(alignment.vertical.itemAlignmentClass)
    }

    /// Renders a group of HTML elements with consistent styling and attributes.
    /// - Parameters:
    ///   - passthrough: The passthrough entity containing the HTML elements to render.
    ///   - attributes: HTML attributes to apply to each element in the group.
    /// - Returns: A view containing the styled group elements.
    func handlePassthrough(_ passthrough: any PassthroughElement, attributes: CoreAttributes) -> some HTML {
        let gutterClass = if case .semantic(let amount) = spacingAmount {
            "g-\(amount.rawValue)"
        } else {
            ""
        }

        return ForEach(passthrough.items) { item in
            handleItem(item.attributes(attributes))
                .class(gutterClass)
                .render()
        }
    }

    /// Calculates the appropriate Bootstrap column class name for a block element.
    /// - Parameter item: The block element to calculate the class name for.
    /// - Returns: A Bootstrap class name that represents the element's width,
    /// scaled according to the grid's column count if needed.
    private func scaleWidthClass(_ widthClass: String) -> String {
        if let columnCount, let width = Int(widthClass.dropFirst("col-md-".count)) {
            // Scale the width to be relative to the new column count
            let scaledWidth = width * 12 / columnCount
            return ColumnWidth.count(scaledWidth).className
        } else {
            return widthClass
        }
    }
}
