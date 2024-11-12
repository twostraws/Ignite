//
//  Abbreviation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation

/// Renders an abbreviation.
public struct Abbreviation: InlineElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The contents of this abbreviation.
    public var contents: any InlineElement

    /// Creates a new `Abbreviation` instance.
    /// - Parameter abbreviation: The abbreviation.
    /// - Parameter description: The description of the abbreviation.
    public init(_ abbreviation: String, description: String) {
        contents = abbreviation
        let customAttribute = AttributeValue(name: "title", value: description)
        attributes.customAttributes.insert(customAttribute)
    }

    /// Creates a new `Abbreviation` instance using an inline element builder
    /// that returns an array of content to place inside.
    /// - Parameter description: The description of the abbreviation.
    public init(_ description: String, @InlineElementBuilder content: () -> some InlineElement) {
        contents = content()
        let customAttribute = AttributeValue(name: "title", value: description)
        attributes.customAttributes.insert(customAttribute)
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        return "<abbr\(attributes.description)>\(contents.render(context: context))</abbr>"
    }
}
