//
// List.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Creates a list of items, either ordered or unordered.
public struct List: BlockElement {
    /// Controls whether this list contains items in a specific order or not.
    public enum ListStyle {
        /// This list contains items that are ordered, which normally means
        /// they are rendered with numbers such as 1, 2, 3.
        case ordered(OrderedListStyle)

        /// This list contains items that are unordered, which normally means
        /// they are rendered with bullet points.
        case unordered(UnorderedListStyle)

        /// This list is unordered, with a custom symbol for bullet points.
        /// **Note:** Although you can technically pass more than one
        /// emoji here, you might find the alignment gets strange.
        case custom(String)
    }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The current style for this list. Defaults to `.unordered`.
    var style = ListStyle.unordered(.default)

    /// The items to show in this list. This may contain any page elements,
    /// but if you need specific styling you might want to use ListItem objects.
    var items: [any PageElement]

    /// Returns the correct HTML name for this list.
    private var listElementName: String {
        if case .ordered(_) = style {
            "ol"
        } else {
            "ul"
        }
    }

    /// Creates a new `List` object using a page element builder that returns
    /// an array of `PageElement` objects to display in the list.
    /// - Parameter items: The content you want to display in your list.
    public init(@PageElementBuilder items: () -> [PageElement]) {
        self.items = items()
    }

    /// Adjusts the style of this list.
    /// - Parameter style: The new style.
    /// - Returns: A new `List` instance with the updated style.
    public func listStyle(_ style: ListStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var listStyleType = ""

        if case .ordered(let orderedStyle) = style {
            // Only add the extra styling if we aren't using
            // the default.
            if orderedStyle != .default {
                listStyleType = orderedStyle.rawValue
            }
        } else if case .unordered(let unorderedListStyle) = style {
            // Only add the extra styling if we aren't using
            // the default.
            if unorderedListStyle != .default {
                listStyleType = String(describing: unorderedListStyle)
            }
        } else if case .custom(let symbol) = style {
            // We need to convert our symbol to something
            // Unicode friendly, in case they use emoji.
            var cssHex = ""

            for scalar in symbol.unicodeScalars {
                let hexValue = String(format: "%X", scalar.value)
                cssHex += "\\\(hexValue)"
            }

            listStyleType = "'\(cssHex)'"
        }

        var listAttributes = attributes

        if listStyleType.isEmpty == false {
            listAttributes.append(styles: "list-style-type: \(listStyleType)")
        }

        var output = "<\(listElementName)\(listAttributes.description)>"

        for item in items {
            if item is ListItem {
                output += item.render(context: context)
            } else {
                output += "<li>\(item.render(context: context))</li>"
            }

        }

        output += "</\(listElementName)>"

        return output
    }
}
