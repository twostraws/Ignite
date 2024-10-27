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
    var value: (any Environment.MediaQueryValue)?

    public init(isTransparent: Bool = false, @ElementBuilder<BaseElement> _ items: () -> [BaseElement]) {
        self.items = items()
        self.isTransparent = isTransparent
        self.value = (any Environment.MediaQueryValue)?.none
    }

    /// Creates a group whose visibility is dependent on a media-query-driven environment value.
    public init<T: Environment.MediaQueryValue>(_ type: T.Type, equals value: T, @ElementBuilder<BaseElement> _ items: () -> [BaseElement]) {
        self.items = items()
        self.isTransparent = false
        self.value = value
    }

    init(items: [BaseElement], context: PublishingContext) {
        self.items = items
        self.isTransparent = true
        self.value = nil
    }

    public func render(context: PublishingContext) -> String {
        if isTransparent {
            return items.render(context: context)
        } else if let value {
            return "<div class=\"\(value.key)-\(value.rawValue)\">\(items.render(context: context))</div>"
        } else {
            return "<div\(attributes.description)>\(items.render(context: context))</div>"
        }
    }
}
