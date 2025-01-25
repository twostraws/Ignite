//
// ListItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Creates one item in a list. This isn't always needed, because you can place other
/// elements directly into lists if you wish. Use `ListItem` when you specifically
/// need a styled HTML <li> element.
public struct ListItem: HTML, ListableElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The content of this list item.
    var content: any InlineHTML

    /// Creates a new `ListItem` object using an inline element builder that
    /// returns an array of `HTML` objects to display in the list.
    /// - Parameter content: The content you want to display in your list.
    public init(@InlineHTMLBuilder content: () -> some InlineHTML) {
        self.content = content()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        attributes.tag = "li"
        return attributes.description(wrapping: content.render())
    }

    /// Renders this element inside a list, using the publishing context passed in.
    /// - Returns: The HTML for this element.
    public func renderInList() -> String {
        // We do nothing special here, so just send back
        // the default rendering.
        render()
    }
}

public extension ListItem {
    /// The type of HTML this element returns after attributes have been applied.
    typealias AttributedHTML = Self

    func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: id)
        return self
    }

    func data(_ name: String, _ value: String) -> Self {
        attributes.data(name, value, persistentID: id)
        return self
    }

    @discardableResult func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: id)
        return self
    }
}
