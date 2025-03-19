//
// Quote.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A block quote of text.
public struct Quote: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

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
        @InlineElementBuilder caption: () -> some InlineElement
    ) {
        self.contents = contents()
        self.caption = caption()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        attributes.append(classes: "blockquote")

        let renderedContents = contents.render()
        let renderedCaption = caption.render()

        if renderedCaption.isEmpty {
            return "<blockquote\(attributes)>\(renderedContents)</blockquote>"
        } else {
            let footer = "<footer class=\"blockquote-footer\">\(renderedCaption)</footer>"
            return "<blockquote\(attributes)>\(renderedContents + footer)</blockquote>"
        }
    }
}
