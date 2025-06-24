//
// InlineHTML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that represents the HTML representation of `InlineElement`.
public struct InlineHTML<Content: InlineElement>: HTML {
    /// The body of this HTML element.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The underlying HTML content, unattributed.
    private var content: Content

    /// The underlying HTML content, attributed.
    private var attributedContent: Content {
        var content = content
        content.attributes.merge(attributes)
        return content
    }

    /// Creates a new `InlineHTML` instance that wraps the given HTML content.
    /// - Parameter content: The HTML content to wrap
    init(_ content: Content) {
        self.content = content
    }

    /// Renders the wrapped HTML content using the given publishing context
    /// - Returns: The rendered HTML string
    public func render() -> Markup {
        attributedContent.render()
    }
}

extension InlineHTML: FormElementRenderable where Content: FormElementRenderable {
    func renderAsFormElement(_ configuration: FormConfiguration) -> Markup {
        attributedContent.renderAsFormElement(configuration)
    }
}
