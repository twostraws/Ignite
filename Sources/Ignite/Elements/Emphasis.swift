//
// Emphasis.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Renders text with emphasis, which usually means italics.
public struct Emphasis: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The content you want to render with emphasis.
    var content: any InlineElement

    /// Creates a new `Emphasis` instance using an inline element builder
    /// of content to display.
    /// - Parameter content: The content to render with emphasis.
    public init(
        @InlineHTMLBuilder content: () -> some InlineElement
    ) {
        self.content = content()
    }

    /// Creates a new `Emphasis` instance using a single inline element.
    /// - Parameter singleElement: The content to render with emphasis.
    public init(_ singleElement: any InlineElement) {
        self.content = singleElement
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        attributes.tag = "em"
        return attributes.description(wrapping: content.render())
    }
}
