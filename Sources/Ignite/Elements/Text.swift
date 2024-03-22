//
// Text.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A structured piece of text, such as a paragraph of heading. If you are just
/// placing content inside a list, table, table header, and so on, you can usually
/// just use a simple string. Using `Text` is required if you want a specific paragraph
/// of text with some styling, or a header of a particular size.
public struct Text: BlockElement, DropdownElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The font to use for this text.
    var font = Font.body

    /// The content to place inside the text.
    var content: [InlineElement]

    /// Creates a new `Text` instance using an inline element builder that
    /// returns an array of the content to place into the text.
    /// - Parameter content: An array of the content to place into the text.
    public init(@InlineElementBuilder content: () -> [InlineElement]) {
        self.content = content()
    }

    /// Creates a new `Text` instance from one inline element.
    public init(_ string: any InlineElement) {
        self.content = [string]
    }

    /// Creates a new Text struct from a Markdown string.
    /// - Parameter markdown: The Markdown text to parse.
    public init(markdown: String) {
        let parser = MarkdownToHTML(markdown: markdown)

        // Remove any <p></p> tags, because these will be
        // added automatically in render(). This allows us
        // to retain any styling applied elsewhere, e.g.
        // the `font()` modifier.
        let cleanedHTML = parser.body.replacing(#/<\/?p>/#, with: "")
        self.content = [cleanedHTML]
    }

    /// Adjusts the font of this text.
    /// - Parameter newFont: The new font.
    /// - Returns: A new `Text` instance with the updated font.
    public func font(_ newFont: Font) -> Self {
        if newFont == .lead {
            return self.class("lead")
        } else {
            var copy = self
            copy.font = newFont
            return copy
        }
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<\(font.rawValue)\(attributes.description)>" + content.render(context: context) + "</\(font.rawValue)>"
    }
}
