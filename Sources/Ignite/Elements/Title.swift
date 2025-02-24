//
// Title.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Provides the title for a given page, which is rendered in the browser and also
/// appears in search engine results.
public struct Title: HeadElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// A plain-text string for the page title.
    var text: String

    /// Creates a new page title using the plain-text string provided.
    /// - Parameter text: The title to use for this page.
    public init(_ text: String) {
        self.text = text
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        "<title>\(text)\(publishingContext.site.titleSuffix)</title>"
    }
}
