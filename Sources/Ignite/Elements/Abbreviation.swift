//
//  Abbreviation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation

/// Renders an abbreviation.
public struct Abbreviation: InlineElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The contents of this abbreviation.
    public var contents: [InlineElement]

    /// Creates a new `Abbreviation` instance.
    /// - Parameter abbreviation: The abbreviation.
    /// - Parameter description: The description of the abbreviation.
    public init(_ abbreviation: String, description: String) {
        let customAttribute = AttributeValue(name: "title", value: description)

        self.attributes.customAttributes.append(customAttribute)
        self.contents = [abbreviation]
    }

    /// Creates a new `Abbreviation` instance.
    /// - Parameter singleElement: The element you want to place
    /// - Parameter description: The description of the abbreviation.
    public init(_ singleElement: any InlineElement, description: String) {
        let customAttribute = AttributeValue(name: "title", value: description)

        self.attributes.customAttributes.append(customAttribute)
        self.contents = [singleElement]
    }

    /// Creates a new `Abbreviation` instance using an inline element builder
    /// that returns an array of content to place inside.
    /// - Parameter description: The description of the abbreviation.
    public init(_ description: String, @InlineElementBuilder content: () -> [InlineElement]) {
        let customAttribute = AttributeValue(name: "title", value: description)

        self.attributes.customAttributes.append(customAttribute)
        self.contents = content()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<abbr\(attributes.description)>\(contents.render(context: context))</abbr>"
    }
}
