//
// Code.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// An inline snippet of programming code, embedded inside a larger part
/// of your page. For dedicated code blocks that sit on their own line, use
/// `CodeBlock` instead.
///
/// - Important: If your code contains angle brackets (`<`...`>`), such as Swift generics,
/// the prettifier will interpret these as HTML tags and break the code's formatting.
/// To avoid this issue, either set your site’s `shouldPrettify` property to `false`,
/// or replace `<` and `>` with their character entity references, `&lt;` and `&gt;` respectively.
public struct Code: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

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
    "<code\(attributes)>\(content)</code>"
    }
}
