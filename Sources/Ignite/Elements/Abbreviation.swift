//
//  Abbreviation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation

/// Renders an abbreviation.
public struct Abbreviation: InlineHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The contents of this abbreviation.
    public var contents: any InlineHTML

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
    public init(_ description: String, @InlineHTMLBuilder content: () -> some InlineHTML) {
        contents = content()
        let customAttribute = AttributeValue(name: "title", value: description)
        attributes.customAttributes.insert(customAttribute)
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "abbr"
        return attributes.description(wrapping: contents.render(context: context))
    }
}
