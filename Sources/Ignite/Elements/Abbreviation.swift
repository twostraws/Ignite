//
// Abbreviation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Renders an abbreviation.
public struct Abbreviation: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The contents of this abbreviation.
    public var contents: any InlineElement

    /// Creates a new `Abbreviation` instance.
    /// - Parameter abbreviation: The abbreviation.
    /// - Parameter description: The description of the abbreviation.
    public init(_ abbreviation: String, description: String) {
        contents = abbreviation
        let customAttribute = Attribute(name: "title", value: description)
        attributes.append(customAttributes: customAttribute)
    }

    /// Creates a new `Abbreviation` instance using an inline element builder
    /// that returns an array of content to place inside.
    /// - Parameters:
    ///   - description: The description of the abbreviation.
    ///   - content: The elements to place inside the abbreviation.
    public init(_ description: String, @InlineElementBuilder content: () -> some InlineElement) {
        contents = content()
        let customAttribute = Attribute(name: "title", value: description)
        attributes.append(customAttributes: customAttribute)
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        "<abbr\(attributes)>\(contents.render())</abbr>"
    }
}
