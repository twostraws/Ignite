//
// CodeBlock.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An separated section of programming code. For inline code that sit along other
/// text on your page, use `Code` instead.
public struct CodeBlock: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The code to display.
    var content: String

    /// The language of the code being shown.
    var language: String?

    /// Creates a new `Code` instance from the given content.
    /// - Parameters:
    ///   - language: The programming language for the code. This affects
    ///   how the content is tagged, which in turn affects syntax highlighting.
    ///   - content: The code you want to render.
    public init(language: String? = nil, _ content: String) {
        self.language = language
        self.content = content
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        if let language {
            """
            <pre\(attributes.description())>\
            <code class=\"language-\(language)\">\
            \(content)\
            </code>\
            </pre>
            """
        } else {
            """
            <pre\(attributes.description())>\
            <code>\(content)</code>\
            </pre>
            """
        }
    }
}
