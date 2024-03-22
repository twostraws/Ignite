//
// Code.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An inline snippet of programming code, embedded inside a larger part
/// of your page. For dedicated code blocks that sit on their own line, use
/// `CodeBlock` instead.
public struct Code: InlineElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The code to display.
    var content: String

    /// Creates a new `Code` instance from the given content.
    /// - Parameter content: The code you want to render.
    public init(_ content: String) {
        self.content = content
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<code\(attributes.description)>\(content)</code>"
    }
}
