//
// Span.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// An inline subsection of another element, useful when you need to style
/// just part of some text, for example.
public struct Span: InlineElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The contents of this span.
    public var contents: [InlineElement]

    /// Creates a span with no content. Used in some situations where
    /// exact styling is performed by Bootstrap, e.g. in Carousel.
    public init() {
        self.contents = []
    }

    /// Creates a span from one `InlineElement`.
    /// - Parameter singleElement: The element you want to place
    /// inside the span.
    public init(_ singleElement: any InlineElement) {
        self.contents = [singleElement]
    }

    /// Creates a span from an inline element builder that returns an array of
    /// elements to place inside the span.
    /// - Parameter contents: The elements to place inside the span.
    public init(@InlineElementBuilder contents: () -> [InlineElement]) {
        self.contents = contents()
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<span\(attributes.description)>\(contents.render(context: context))</span>"
    }
}
