//
// ButtonGroup.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A container that automatically adjusts the styling for buttons it contains so
/// that they sit more neatly together.
public struct ButtonGroup<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// A required screen reader description for this element.
    private var accessibilityLabel: String

    /// The buttons that should be displayed in this gorup.
    private var content: Content

    /// Creates a new `ButtonGroup` from the accessibility label and an
    /// element builder that must return the buttons to use.
    /// - Parameters:
    ///   - accessibilityLabel: A required description of this group
    ///   for screenreaders.
    ///   - content: An element builder containing the contents for this group.
    public init<C>(
        accessibilityLabel: String,
        @ButtonElementBuilder content: () -> C
    ) where Content == ButtonElementBuilder.Content<C>, C: ButtonElement {
        self.accessibilityLabel = accessibilityLabel
        self.content = ButtonElementBuilder.Content(content())
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        Section(content)
            .class("btn-group")
            .aria(.label, accessibilityLabel)
            .customAttribute(name: "role", value: "group")
            .render()
    }
}
