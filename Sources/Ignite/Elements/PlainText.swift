//
// PlainText.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A small String extension that allows strings to be used directly inside HTML.
/// Useful when you don't want your text to be wrapped in a paragraph or similar.
extension String: InlineHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        self
    }
}
