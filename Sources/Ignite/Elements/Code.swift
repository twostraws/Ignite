//
// Code.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An inline snippet of programming code, embedded inside a larger part
/// of your page. For dedicated code blocks that sit on their own line, use
/// `CodeBlock` instead.
public struct Code: InlineHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The default display type associated with this HTML element.
    public var displayType: DisplayType = .inline

    /// The code to display.
    var content: String

    /// Creates a new `Code` instance from the given content.
    /// - Parameter content: The code you want to render.
    public init(_ content: String) {
        self.content = content
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        attributes.tag = "code"
        return attributes.description(wrapping: content)
    }
}
