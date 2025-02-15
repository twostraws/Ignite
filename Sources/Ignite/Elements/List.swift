//
// List.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates a list of items, either ordered or unordered.
public struct List: BlockHTML {
    /// Controls whether this list contains items in a specific order or not.
    public enum ListMarkerStyle {
        /// This list contains items that are ordered, which normally means
        /// they are rendered with numbers such as 1, 2, 3.
        case ordered(OrderedListMarkerStyle)

        /// This list contains items that are unordered, which normally means
        /// they are rendered with bullet points.
        case unordered(UnorderedListMarkerStyle)

        /// This list is unordered, with a custom symbol for bullet points.
        /// **Note:** Although you can technically pass more than one
        /// emoji here, you might find the alignment gets strange.
        case custom(String)
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    /// The current style for this list. Defaults to `.plain`.
    private var listStyle: ListStyle = .plain

    /// The current style for the list item markers. Defaults to `.unordered`.
    private var markerStyle = ListMarkerStyle.unordered(.automatic)

    /// The items to show in this list. This may contain any page elements,
    /// but if you need specific styling you might want to use ListItem objects.
    private var items: [any HTML]

    /// Returns the correct HTML name for this list.
    private var listElementName: String {
        if case .ordered = markerStyle {
            "ol"
        } else {
            "ul"
        }
    }

    /// Creates a new `List` object using a page element builder that returns
    /// an array of `HTML` objects to display in the list.
    /// - Parameter items: The content you want to display in your list.
    public init(@HTMLBuilder items: () -> some HTML) {
        self.items = flatUnwrap(items())
    }

    /// Adjusts the style of this list.
    /// - Parameter style: The new style.
    /// - Returns: A new `List` instance with the updated style.
    public func listStyle(_ style: ListStyle) -> Self {
        var copy = self
        copy.listStyle = style
        return copy
    }

    /// Adjusts the style of the list item markers.
    /// - Parameter style: The new style.
    /// - Returns: A new `List` instance with the updated style.
    public func listMarkerStyle(_ style: ListMarkerStyle) -> Self {
        var copy = self
        copy.markerStyle = style
        return copy
    }

    private func getAttributes() -> CoreAttributes {
        var listAttributes = attributes

        if listStyle != .plain {
            listAttributes.append(classes: "list-group")
        } else if listStyle == .flushGroup {
            listAttributes.append(classes: "list-group-flush")
        }

        var listMarkerType = ""

        if case .ordered(let orderedStyle) = markerStyle {
            // Only add the extra styling if we aren't using
            // the default.
            if orderedStyle != .automatic {
                listMarkerType = orderedStyle.rawValue
            }

            if listStyle == .group {
                listAttributes.append(classes: "list-group-numbered")
            }
        } else if case .unordered(let unorderedListStyle) = markerStyle {
            // Only add the extra styling if we aren't using
            // the default.
            if unorderedListStyle != .automatic {
                listMarkerType = String(describing: unorderedListStyle)
            }
        } else if case .custom(let symbol) = markerStyle {
            // We need to convert our symbol to something
            // Unicode friendly, in case they use emoji.
            var cssHex = ""

            for scalar in symbol.unicodeScalars {
                let hexValue = String(format: "%X", scalar.value)
                cssHex += "\\\(hexValue)"
            }

            listMarkerType = "'\(cssHex)'"
        }

        if listMarkerType.isEmpty == false {
            listAttributes.append(style: .listStyleType, value: listMarkerType)
        }

        return listAttributes
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        let listAttributes = getAttributes()

        var output = "<\(listElementName)\(listAttributes.description())>"

        for item in items {
            // Any element that renders its own <li> (e.g. ForEach) should
            // be allowed to handle that itself.
            if let listableItem = item as? ListableElement {
                if listStyle != .plain {
                    item.class("list-group-item")
                }

                output += listableItem.renderInList()
            } else {
                let styleClass = listStyle != .plain ? " class=\"list-group-item\"" : ""
                item.class("m-0")
                output += "<li\(styleClass)>\(item.render())</li>"
            }
        }

        output += "</\(listElementName)>"

        return output
    }
}
