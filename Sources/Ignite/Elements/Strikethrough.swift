//
// Strikethrough.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Renders text with a strikethrough effect.
public struct Strikethrough<Content: InlineElement>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The content that should be stricken.
    private var content: Content

    /// Creates a new `Strikethrough` instance using an inline element builder
    /// that returns an array of content to place inside.
    public init(@InlineElementBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates a new `Strikethrough` instance using one `InlineElement`
    /// that should be rendered with a strikethrough effect.
    /// - Parameter singleElement: The element to strike.
    public init(_ singleElement: Content) {
        self.content = singleElement
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let contentHTML = content.markupString()
        return Markup("<s\(attributes)>\(contentHTML)</s>")
    }
}
