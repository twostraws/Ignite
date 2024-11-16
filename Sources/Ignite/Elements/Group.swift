//
// Group.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Creates some arbitrary group of content in your page. This is used extensively
/// on the modern web pages to divide pages up into smaller, styled sections.
public struct Group: BlockElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    var items: [BaseElement]
    var isTransparent: Bool

    public init(isTransparent: Bool = false, @ElementBuilder<BaseElement> _ items: () -> [BaseElement]) {
        self.items = items()
        self.isTransparent = isTransparent
    }

    init(items: [BaseElement], context: PublishingContext) {
        self.items = items
        self.isTransparent = true
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        if isTransparent {
            items.render(context: context)
        } else {
            "<div\(attributes.description)>\(items.render(context: context))</div>"
        }
    }
}
