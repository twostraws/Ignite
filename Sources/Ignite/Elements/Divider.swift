//
// Divider.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A horizontal divider for your page, that can also be used to divide elements
/// in a dropdown.
public struct Divider: BlockElement, DropdownElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// Creates a new divider.
    public init() {}

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<hr\(attributes.description) />"
    }
}
