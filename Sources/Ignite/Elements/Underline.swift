//
// Underline.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Renders text with an underline.
public struct Underline<Content: InlineElement>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The content that should be underlined.
    var content: Content

    /// Creates a new `Underline` instance using an inline element builder
    /// that returns an array of content to place inside.
    public init(@InlineElementBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates a new `Underline` instance using one `InlineElement`
    /// that should be rendered with a strikethrough effect.
    /// - Parameter singleElement: The element to strike.
    public init(_ singleElement: Content) {
        self.content = singleElement
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let contentHTML = content.markupString()
        return Markup("<u\(attributes)>\(contentHTML)</u>")
    }
}
