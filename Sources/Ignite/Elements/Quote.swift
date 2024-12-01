//
// Quote.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A block quote of text.
public struct Quote: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The content of this quote.
    var contents: any HTML

    /// Provide details about this quote, e.g. a source name.
    var caption: any InlineHTML

    /// Create a new quote from a page element builder that returns an array
    /// of elements to display in the quote.
    /// - Parameter contents: The elements to display inside the quote.
    public init(@HTMLBuilder contents: () -> some HTML) {
        self.contents = contents()
        self.caption = EmptyHTML()
    }

    /// Create a new quote from a page element builder that returns an array
    /// of elements to display in the quote, and also an inline element builder
    /// that specifics the caption to use. This is useful when you want to add
    /// the source of the quote, e.g. who said it or where it was said.
    /// - Parameters:
    /// - contents: The elements to display inside the quote.
    /// - contents: Additional details about the quote, e.g. its source.
    public init(
        @HTMLBuilder contents: () -> some HTML,
        @InlineHTMLBuilder caption: () -> some InlineHTML
    ) {
        self.contents = contents()
        self.caption = caption()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        let renderedContents = contents.render(context: context)
        let renderedCaption = caption.render(context: context)
        var attributes = attributes

        attributes.tag = "blockquote"
        attributes.append(classes: "blockquote")

        if renderedCaption.isEmpty {
            return attributes.description(wrapping: renderedContents)
        } else {
            var footerAttributes = CoreAttributes()
            footerAttributes.tag = "footer"
            footerAttributes.append(classes: "blockquote-footer")
            let footer = footerAttributes.description(wrapping: renderedCaption)
            return attributes.description(wrapping: renderedContents + footer)
        }
    }
}
