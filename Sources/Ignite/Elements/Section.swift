//
// Section.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates one distinct section on your page, where content inside is fitted to
/// a 12-column grid. If the items in your section have widths that add up to
/// 12 then they will fit in a single row, otherwise they will be placed on multiple
/// rows. This element automatically adapts to constrained horizontal dimensions
/// by placing your content across multiple rows automatically.
///
/// **Note**: A 12-column grid is the default, but you can adjust that downwards
/// by using the `columns()` modifier.
public struct Section: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// How many columns this should be divided into
    var columnCount: Int?

    /// The amount of space between elements.
    private var spacingAmount: SpacingType?

    /// The items to display in this section.
    private var items: [any HTML]

    /// Creates a new `Section` object using a block element builder
    /// that returns an array of items to use in this section.
    /// - Parameters:
    ///   - spacing: The size between each element.
    ///   - items: The items to use in this section.
    public init(spacing: SpacingAmount? = nil, @HTMLBuilder items: () -> some HTML) {
        self.items = flatUnwrap(items())
        if let spacing {
            self.spacingAmount = .semantic(spacing)
        }
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
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var sectionAttributes = attributes.appending(classes: ["row"])

        // If a column count is set, we want to use that for all
        // page sizes that are medium and above. Below that we
        // should drop down to width 1 to avoid squeezing things
        // into oblivion.
        if let columnCount {
            sectionAttributes.append(classes: [
                "row-cols-1",
                "row-cols-md-\(columnCount)"
            ])
        }

        var gutterClass = ""

        if let spacingAmount {
            switch spacingAmount {
            case .exact(let pixels):
                sectionAttributes.append(styles: .init(name: .rowGap, value: "\(pixels)px"))
            case .semantic(let amount):
                gutterClass = "gy-\(amount.rawValue)"
            }
        }

        return GroupBox {
            ForEach(items) { item in
                if let group = item as? Group {
                    handleGroup(group, attributes: group.attributes)
                } else if let modified = item as? ModifiedHTML,
                          let group = modified.content as? Group {
                    handleGroup(group, attributes: modified.attributes)
                } else if let item = item as? any BlockHTML {
                    GroupBox(item)
                        .class(className(for: item))
                        .class(gutterClass)
                } else {
                    item
                }
            }
        }
        .attributes(sectionAttributes)
        .render(context: context)
    }

    /// Renders a group of HTML elements with consistent styling and attributes.
    /// - Parameters:
    ///   - group: The group containing the HTML elements to render.
    ///   - attributes: HTML attributes to apply to each element in the group.
    /// - Returns: A view containing the styled group elements.
    func handleGroup(_ group: Group, attributes: CoreAttributes) -> some HTML {
        let gutterClass = if case .semantic(let amount) = spacingAmount {
            "g-\(amount.rawValue)"
        } else {
            ""
        }
        return ForEach(group.items) { item in
            if let item = item as? any BlockHTML {
                GroupBox(item)
                    .class(className(for: group))
                    .class(gutterClass)
                    .attributes(attributes)
            }
        }
    }

    /// Calculates the appropriate Bootstrap column class name for a block element.
    /// - Parameter item: The block element to calculate the class name for.
    /// - Returns: A Bootstrap class name that represents the element's width, scaled according to the section's column count if needed.
    private func className(for item: any BlockHTML) -> String {
        let className: String
        if let columnCount, case .count(let width) = item.columnWidth {
            // Scale the width to be relative to the new column count
            let scaledWidth = width * 12 / columnCount
            return ColumnWidth.count(scaledWidth).className
        } else {
            className = item.columnWidth.className
        }
        return className
    }
}
