//
// Quote.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A block quote of text.
public struct Quote: BlockElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The content of this quote.
    var contents: [PageElement]

    /// Provide details about this quote, e.g. a source name.
    var caption: [InlineElement]

    /// Create a new quote from a page element builder that returns an array
    /// of elements to display in the quote.
    /// - Parameter contents: The elements to display inside the quote.
    public init(@PageElementBuilder contents: () -> [PageElement]) {
        self.contents = contents()
        self.caption = []
    }

    /// Create a new quote from a page element builder that returns an array
    /// of elements to display in the quote, and also an inline element builder
    /// that specifics the caption to use. This is useful when you want to add
    /// the source of the quote, e.g. who said it or where it was said.
    /// - Parameters:
    /// - contents: The elements to display inside the quote.
    /// - contents: Additional details about the quote, e.g. its source.
    public init(
        @PageElementBuilder contents: () -> [PageElement],
        @InlineElementBuilder caption: () -> [InlineElement]
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

        let blockQuoteAttributes = attributes.appending(classes: ["blockquote"])

        if renderedCaption.isEmpty {
            return """
            <blockquote\(blockQuoteAttributes.description)>\(renderedContents)</blockquote>
            """
        } else {
            return """
            <blockquote class="blockquote">\
            \(renderedContents)\
            <footer class="blockquote-footer">\(renderedCaption)</footer>\
            </blockquote>
            """
        }
    }
}
