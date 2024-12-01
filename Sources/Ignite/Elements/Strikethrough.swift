//
// Strikethrough.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Renders text with a strikethrough effect.
public struct Strikethrough: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The content that should be stricken.
    var content: any InlineElement

    /// Creates a new `Strikethrough` instance using an inline element builder
    /// that returns an array of content to place inside.
    public init(@InlineElementBuilder content: () -> some InlineElement) {
        self.content = content()
    }

    /// Creates a new `Strikethrough` instance using one `InlineElement`
    /// that should be rendered with a strikethrough effect.
    /// - Parameter singleElement: The element to strike.
    public init(_ singleElement: any InlineElement) {
        self.content = singleElement
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<s\(attributes.description())>\(content.render(context: context))</s>"
    }
}
