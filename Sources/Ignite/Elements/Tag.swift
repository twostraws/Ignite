//
// Tag.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A struct able to become any HTML tag. Useful for when Ignite has not
/// implemented a specific tag you need.
public struct Tag: HTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The name of the tag to use
    var name: String

    // The contents of this tag.
    var content: any HTML

    /// Creates a new `Tag` instance from the name provided, along with a page
    /// element builder that returns an array of the content to place inside.
    /// - Parameters:
    ///   - name: The name of the HTML tag you want to create.
    ///   - content: The content to place inside the tag.
    public init(_ name: String, @HTMLBuilder content: @escaping () -> some HTML) {
        self.name = name
        self.content = content()
    }

    /// Creates a new `Tag` instance from the name provided, along with one
    /// page element to place inside.
    /// - Parameters:
    ///   - name: The name of the HTML tag you want to create.
    ///   - content: The content to place inside the tag.
    public init(_ name: String, content singleElement: some HTML) {
        self.name = name
        self.content = singleElement
    }

    /// Creates a new `Tag` instance from the name provided, with no content
    /// inside the tag.
    ///   - name: The name of the HTML tag you want to create.
    public init(_ name: String) {
        self.name = name
        self.content = EmptyHTML()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = name
        return attributes.description(wrapping: content.render(context: context))
    }
}
