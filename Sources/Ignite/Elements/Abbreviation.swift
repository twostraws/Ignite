//
// Abbreviation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Renders an abbreviation.
public struct Abbreviation<Content: InlineElement>: InlineElement {
    /// The content and behavior of this HTML.
    public var body: Never { fatalError() }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The contents of this abbreviation.
    public var content: Content

    /// Creates a new `Abbreviation` instance.
    /// - Parameter abbreviation: The abbreviation.
    /// - Parameter description: The description of the abbreviation.
    public init(_ abbreviation: String, description: String) where Content == String {
        self.content = abbreviation
        let customAttribute = Attribute(name: "title", value: description)
        attributes.append(customAttributes: customAttribute)
    }

    /// Creates a new `Abbreviation` instance using an inline element builder
    /// that returns an array of content to place inside.
    /// - Parameters:
    ///   - description: The description of the abbreviation.
    ///   - content: The elements to place inside the abbreviation.
    public init(_ description: String, @InlineElementBuilder content: () -> Content) {
        self.content = content()
        let customAttribute = Attribute(name: "title", value: description)
        attributes.append(customAttributes: customAttribute)
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        let contentHTML = content.markupString()
        return Markup("<abbr\(attributes)>\(contentHTML)</abbr>")
    }
}
