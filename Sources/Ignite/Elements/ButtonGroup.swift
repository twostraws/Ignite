//
// ButtonGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that automatically adjusts the styling for buttons it contains so
/// that they sit more neatly together.
public struct ButtonGroup: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

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
    /// - Returns: The HTML for this element.
    public func render() -> String {
        Section {
            content.map { $0.render() }.joined()
        }
        .class("btn-group")
        .aria(.label, accessibilityLabel)
        .customAttribute(name: "role", value: "group")
        .render()
    }
}
