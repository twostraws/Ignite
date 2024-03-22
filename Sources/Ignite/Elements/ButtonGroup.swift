//
// ButtonGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A container that automatically adjusts the styling for buttons it contains so
/// that they sit more neatly together.
public struct ButtonGroup: BlockElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// A required screen reader description for this element.
    var accessibilityLabel: String

    /// The buttons that should be displayed in this gorup.
    var content: [Button]

    /// Creates a new `ButtonGroup` from the accessibility label and an
    /// element builder that must return the buttons to use.
    /// - Parameters:
    ///   - accessibilityLabel: A required description of this group
    ///   for screenreaders.
    ///   - content: An element builder containing the contents for this group.
    public init(
        accessibilityLabel: String,
        @ElementBuilder<Button> _ content: () -> [Button]
    ) {
        self.accessibilityLabel = accessibilityLabel
        self.content = content()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        Group {
            content.map { $0.render(context: context) }.joined()
        }
        .class("btn-group")
        .aria("label", accessibilityLabel)
        .addCustomAttribute(name: "role", value: "group")
        .render(context: context)
    }
}
