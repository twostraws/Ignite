//
// Tag.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A struct able to become any HTML tag. Useful for when Ignite has not
/// implemented a specific tag you need.
public struct Tag<Content: HTML>: HTML {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The name of the tag to use.
    private var name: String

    // The contents of this tag.
    private var content: Content

    /// Creates a new `Tag` instance from the name provided, along with a page
    /// element builder that returns an array of the content to place inside.
    /// - Parameters:
    ///   - name: The name of the HTML tag you want to create.
    ///   - content: The content to place inside the tag.
    public init(_ name: String, @HTMLBuilder content: () -> Content) {
        self.name = name
        self.content = content()
    }

    /// Creates a new `Tag` instance from the name provided, with no content
    /// inside the tag.
    ///   - name: The name of the HTML tag you want to create.
    public init(_ name: String) where Content == EmptyHTML {
        self.name = name
        self.content = EmptyHTML()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let contentHTML = content.markupString()
        return Markup("<\(name)\(attributes)>\(contentHTML)</\(name)>")
    }
}
