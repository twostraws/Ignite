//
// Underline.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Renders text with an underline.
public struct Underline: InlineHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The content that should be underlined.
    var content: any InlineHTML

    /// Creates a new `Underline` instance using an inline element builder
    /// that returns an array of content to place inside.
    public init(@InlineHTMLBuilder content: @escaping () -> some InlineHTML) {
        self.content = content()
    }

    /// Creates a new `Underline` instance using one `InlineElement`
    /// that should be rendered with a strikethrough effect.
    /// - Parameter singleElement: The element to strike.
    public init(_ singleElement: some InlineHTML) {
        self.content = singleElement
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "u"
        return attributes.description(wrapping: content.render(context: context))
    }
}
