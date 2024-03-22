//
// ContentPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Content pages describe custom page structures for articles. You can provide
/// one layout in your site to use that for all articles, or create custom layouts and
/// assign them uniquely to individual articles.
public protocol ContentPage: ThemedPage {

    /// Renders a layout for a particular piece of content inside the current
    /// publishing context.
    /// - Parameters:
    ///   - content: The content that is being rendered.
    ///   - context: The current publishing context.
    /// - Returns: An array of `BlockElement` objects that should be used
    /// for the content.
    @BlockElementBuilder func body(content: Content, context: PublishingContext) -> [BlockElement]
}

public extension ThemedPage {
    var theme: MissingTheme { MissingTheme() }
}
