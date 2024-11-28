//
// Underline.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Renders text with an underline.
public struct Underline: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The content that should be underlined.
    var content: any InlineElement

    /// Creates a new `Underline` instance using an inline element builder
    /// that returns an array of content to place inside.
    public init(@InlineElementBuilder content: @escaping () -> some InlineElement) {
        self.content = content()
    }

    /// Creates a new `Underline` instance using one `InlineElement`
    /// that should be rendered with a strikethrough effect.
    /// - Parameter singleElement: The element to strike.
    public init(_ singleElement: some InlineElement) {
        self.content = singleElement
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<u\(attributes.description())>\(content.render(context: context))</u>"
    }
}
