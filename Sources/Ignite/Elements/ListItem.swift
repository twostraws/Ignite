//
// ListItem.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

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
    /// - Parameter items: The content you want to display in your list.
    public init(@InlineHTMLBuilder content: () -> some InlineHTML) {
        self.content = content()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "li"
        return attributes.description(wrapping: content.render(context: context))
    }

    /// Renders this element inside a list, using the publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func renderInList(context: PublishingContext) -> String {
        // We do nothing special here, so just send back
        // the default rendering.
        render(context: context)
    }
}
