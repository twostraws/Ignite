//
// List.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates a list of items, either ordered or unordered.
public struct List<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The current style for this list. Defaults to `.automatic`.
    private var listStyle: ListStyle = .automatic

    /// The current style for the list item markers. Defaults to `.unordered`.
    private var markerStyle: ListMarkerStyle = .unordered

    /// The items to show in this list. This may contain any page elements,
    /// but if you need specific styling you might want to use `ListItem` objects.
    private var content: Content

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
    public init(@HTMLBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates a new list from a collection of items, along with a function that converts
    /// a single object from the collection into a list item.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into list items.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns an item representing that value in the list.
    public init<T, S: Sequence, RowContent: HTML>(
        _ items: S,
        @HTMLBuilder content: @escaping (T) -> RowContent
    ) where S.Element == T, Content == ForEach<[T], RowContent> {
        let content = ForEach(Array(items), content: content)
        self.content = content
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

    /// Combines list and marker styles into a single `CoreAttributes` object for rendering.
    private var listAttributes: CoreAttributes {
        var listAttributes = attributes

        if let styleClasses = listStyle.classes, !styleClasses.isEmpty {
            listAttributes.append(classes: styleClasses)
        }

        var listMarkerType = ""

        switch markerStyle {
        case .ordered(let style):
            // Only add the extra styling if we aren't using the default.
            if listStyle != .automatic {
                listAttributes.append(classes: "list-group-numbered")
            }
            if style != .automatic {
                listMarkerType = style.rawValue
            }
        case .unordered(let style):
            guard style != .automatic else { break }
            // Only add the extra styling if we aren't using the default.
            listMarkerType = style.rawValue
        case .custom(let symbol):
            // We need to convert our symbol to something
            // Unicode friendly, in case they use emoji.
            let cssHex = symbol.unicodeScalars
                .map { String(format: "\\%X", $0.value) }
                .joined()

            listMarkerType = "'\(cssHex)'"
        }

        if listMarkerType.isEmpty == false {
            listAttributes.append(style: .listStyleType, value: listMarkerType)
        }

        return listAttributes
    }

    /// Renders an individual list row, wrapping it in a `ListItem` when necessary.
    private func renderListRow(_ content: Subview) -> Markup {
        if content.wrapped is any ListItemProvider {
            var content = content
            content.attributes.append(classes: listStyle != .automatic ? "list-group-item" : nil)
            return content.render()
        } else {
            let styleClass = listStyle == .automatic ? nil : "list-group-item"
            return ListItem { content }
                .class(styleClass)
                .render()
        }
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        var output = "<\(listElementName)\(listAttributes)>"
        output += content.subviews().map { renderListRow($0).string }.joined()
        output += "</\(listElementName)>"
        return Markup(output)
    }
}
