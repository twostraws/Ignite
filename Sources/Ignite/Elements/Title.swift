//
// Title.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Provides the title for a given page, which is rendered in the browser and also
/// appears in search engine results.
public struct Title: HeadElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

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
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<title>\(text)\(context.site.titleSuffix)</title>"
    }
}
