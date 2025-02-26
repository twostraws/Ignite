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
public struct Grid: HTML, HorizontalAligning {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should be divided into
    var columnCount: Int?

    /// The amount of space between elements.
    private var spacingAmount: SpacingType?

    /// The items to display in this section.
    private var items: HTMLCollection

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - spacing: The number of pixels between each element. Default is nil.
    ///   - items: The items to use in this section.
    public init(spacing: Int? = nil, @HTMLBuilder items: () -> some HTML) {
        self.items = HTMLCollection(items)
        if let spacing {
            self.spacingAmount = .exact(spacing)
        }
    }

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - spacing: The predefined size between each element.
    ///   - items: The items to use in this section.
    public init(spacing: SpacingAmount, @HTMLBuilder items: () -> some HTML) {
        self.items = HTMLCollection(items)
        self.spacingAmount = .semantic(spacing)
    }

    /// Adjusts the number of columns that can be fitted into this section.
    /// - Parameter columns: The number of columns to use
    /// - Returns: A new `Section` instance with the updated column count.
    public func columns(_ columns: Int) -> Self {
        var copy = self
        copy.columnCount = columns
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var sectionAttributes = attributes.adding(classes: ["row"])

        // If a column count is set, we want to use that for all
        // page sizes that are medium and above. Below that we
        // should drop down to width 1 to avoid squeezing things
        // into oblivion.
        if let columnCount {
            sectionAttributes.add(classes: [
                "row-cols-1",
                "row-cols-md-\(columnCount)"
            ])
        }

        var gutterClass = ""

        if let spacingAmount {
            switch spacingAmount {
            case .exact(let pixels):
                sectionAttributes.add(styles: .init(.rowGap, value: "\(pixels)px"))
            case .semantic(let amount):
                gutterClass = "gy-\(amount.rawValue)"
            }
        }

        return Section {
            ForEach(items) { item in
                if let passthrough = item as? any PassthroughElement {
                    handlePassthrough(passthrough, attributes: passthrough.attributes)
                } else if let modified = item as? ModifiedHTML,
                          let passthrough = modified.unwrapped as? any PassthroughElement {
                    handlePassthrough(passthrough, attributes: modified.attributes)
                } else {
                    handleItem(item)
                        .class(gutterClass)
                }
            }
        }
        .attributes(sectionAttributes)
        .render()
    }

    /// Removes a column class, if it exists, from the item and reassigns it to a wrapper.
    private func handleItem(_ item: any HTML) -> some HTML {
        var item = item
        var name: String?
        if let widthClass = item.attributes.classes.first(where: { $0.starts(with: "col-md-") }) {
            item.attributes.remove(classes: widthClass)
            name = scaleWidthClass(widthClass)
        }

        return Section(item)
            .class(name ?? "col")
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
        }
    }

    /// Calculates the appropriate Bootstrap column class name for a block element.
    /// - Parameter item: The block element to calculate the class name for.
    /// - Returns: A Bootstrap class name that represents the element's width,
    /// scaled according to the section's column count if needed.
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
