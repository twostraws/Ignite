//
// Span.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An inline subsection of another element, useful when you need to style
/// just part of some text, for example.
public struct Span: InlineHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The contents of this span.
    public var contents: any InlineHTML

    /// Creates a span with no content. Used in some situations where
    /// exact styling is performed by Bootstrap, e.g. in Carousel.
    public init() {
        self.contents = EmptyHTML()
    }

    /// Creates a span from one `InlineElement`.
    /// - Parameter singleElement: The element you want to place
    /// inside the span.
    public init(_ singleElement: some InlineHTML) {
        self.contents = singleElement
    }

    /// Creates a span from an inline element builder that returns an array of
    /// elements to place inside the span.
    /// - Parameter contents: The elements to place inside the span.
    public init(@InlineHTMLBuilder contents: () -> some InlineHTML) {
        self.contents = contents()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "span"
        return attributes.description(wrapping: contents.render(context: context))
    }
}
