//
// List.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates a list of items, either ordered or unordered.
public struct List: HTML {
    /// The visual style to apply to a list.
    public enum Style: Sendable, CaseIterable {
        /// A basic list appearance with no styling.
        case plain

        /// A list style with subtle borders and rounded corners.
        case group

        /// A list style with subtle borders and rounded corners, arranged horizontally.
        case horizontalGroup

        /// A list style with separators between items.
        case separated

        /// The Bootstrap CSS classes needed to implement the list's visual style.
        var classes: [String]? {
            switch self {
            case .plain: nil
            case .group: ["list-group"]
            case .horizontalGroup: ["list-group", "list-group-horizontal"]
            case .separated: ["list-group", "list-group-flush"]
            }
        }
    }

    /// Controls whether this list contains items in a specific order or not.
    public enum ListMarkerStyle {
        /// This list contains items that are ordered, which normally means
        /// they are rendered with numbers such as 1, 2, 3.
        case ordered(OrderedListMarkerStyle)

        /// This list contains items that are unordered, which normally means
        /// they are rendered with bullet points.
        case unordered(UnorderedListMarkerStyle)

        /// This list is unordered, with a custom symbol for bullet points.
        /// - Note: Although you can technically pass more than one
        /// emoji here, you might find the alignment gets strange.
        case custom(String)

        /// A convenience for creating ordered lists with automatic numbering.
        public static var ordered: Self { .ordered(.automatic) }

        /// A convenience for creating unordered lists with automatic bullet points.
        public static var unordered: Self { .unordered(.automatic) }
    }

    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The current style for this list. Defaults to `.plain`.
    private var listStyle: Style = .plain

    /// The current style for the list item markers. Defaults to `.unordered`.
    private var markerStyle: ListMarkerStyle = .unordered(.automatic)

    /// The items to show in this list. This may contain any page elements,
    /// but if you need specific styling you might want to use `ListItem` objects.
    private var items: HTMLCollection

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
    public init(@HTMLBuilder items: () -> some BodyElement) {
        self.items = HTMLCollection(items)
    }

    /// Creates a new list from a collection of items, along with a function that converts
    /// a single object from the collection into a list item.
    /// - Parameters:
    ///   - items: A sequence of items you want to convert into list items.
    ///   - content: A function that accepts a single value from the sequence, and
    ///     returns an item representing that value in the list.
    public init<T>(_ items: any Sequence<T>, content: (T) -> some BodyElement) {
        self.items = HTMLCollection(items.map(content))
    }

    /// Adjusts the style of this list.
    /// - Parameter style: The new style.
    /// - Returns: A new `List` instance with the updated style.
    public func listStyle(_ style: Style) -> Self {
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
    private func getAttributes() -> CoreAttributes {
        var listAttributes = attributes

        if let styleClasses = listStyle.classes, !styleClasses.isEmpty {
            listAttributes.append(classes: styleClasses)
        }

        var listMarkerType = ""

        switch markerStyle {
        case .ordered(let style):
            listAttributes.append(classes: "list-group-numbered")
            guard style != .automatic else { break }
            // Only add the extra styling if we aren't using the default.
            listMarkerType = style.rawValue
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

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func markup() -> Markup {
        let listAttributes = getAttributes()

        var output = "<\(listElementName)\(listAttributes)>"

        for originalItem in items {
            var item = originalItem
            // Any element that renders its own <li> (e.g. ForEach) should
            // be allowed to handle that itself.
            if var listableItem = item as? ListableElement ??
            (item as? AnyHTML)?.body as? ListableElement {
                if listStyle != .plain {
                    listableItem.attributes.append(classes: "list-group-item")
                }
                output += listableItem.listMarkup().string
            } else {
                let styleClass = listStyle == .plain ? "" : " class=\"list-group-item\""
                item.attributes.append(classes: "m-0")
                output += "<li\(styleClass)>\(item.markupString())</li>"
            }
        }

        output += "</\(listElementName)>"

        return Markup(output)
    }
}
