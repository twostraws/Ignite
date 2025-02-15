//
// Quote.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A block quote of text.
public struct Quote: BlockHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// How many columns this should occupy when placed in a grid.
    public var columnWidth = ColumnWidth.automatic

    /// The content of this quote.
    var contents: any HTML

    /// Provide details about this quote, e.g. a source name.
    var caption: any InlineElement

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
        @InlineHTMLBuilder caption: () -> some InlineElement
    ) {
        self.contents = contents()
        self.caption = caption()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        let renderedContents = contents.render()
        let renderedCaption = caption.render()
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
