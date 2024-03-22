//
// Emphasis.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Renders text with emphasis, which usually means italics.
public struct Emphasis: InlineElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The content you want to render with emphasis.
    var content: [InlineElement]

    /// Creates a new `Emphasis` instance using an inline element builder
    /// of content to display.
    /// - Parameter content: The content to render with emphasis.
    public init(
        @InlineElementBuilder content: () -> [InlineElement]
    ) {
        self.content = content()
    }

    /// Creates a new `Emphasis` instance using a single inline element.
    /// - Parameter content: The content to render with emphasis.
    public init(_ singleElement: any InlineElement) {
        self.content = [singleElement]
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<em\(attributes.description)>\(content.render(context: context))</em>"
    }
}
