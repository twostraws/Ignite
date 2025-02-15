//
// Strikethrough.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Renders text with a strikethrough effect.
public struct Strikethrough: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The content that should be stricken.
    var content: any InlineElement

    /// Creates a new `Strikethrough` instance using an inline element builder
    /// that returns an array of content to place inside.
    public init(@InlineHTMLBuilder content: () -> some InlineElement) {
        self.content = content()
    }

    /// Creates a new `Strikethrough` instance using one `InlineElement`
    /// that should be rendered with a strikethrough effect.
    /// - Parameter singleElement: The element to strike.
    public init(_ singleElement: any InlineElement) {
        self.content = singleElement
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        attributes.tag = "s"
        return attributes.description(wrapping: content.render())
    }
}
