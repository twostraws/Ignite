//
// StaticPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One static page in your site, where the content is entirely standalone rather
/// than being produced in conjunction with an external Markdown file.
public protocol StaticPage: ThemedPage {
    /// All pages have a default path generated for them by Ignite, but you can
    /// override that here if you wish.
    var path: String { get }

    /// The title for this page.
    var title: String { get }
    
    /// The image for sharing the page
    var image: URL? { get }

    /// A plain-text description for this page. Defaults to an empty string.
    var description: String { get }

    /// Provides the content of this page using a block element builder that
    /// returns an array of the elements on this page.
    /// - Parameter context: The current publishing context.
    /// - Returns: An array of the elements on this page.
    @BlockElementBuilder func body(context: PublishingContext) -> [BlockElement]
}

public extension StaticPage {
    /// A default description for this page, which is just an empty string.
    var description: String { "" }

    /// Attempts to auto-generate a path for this page using its name then title.
    var path: String {
        // Attempt to use our Swift filename.
        if let suggestedName = String(describing: Self.self).convertedToSlug() {
            "/\(suggestedName)"
        } else if let result = title.convertedToSlug() {
            // If that failed, attempt to convert our title.
            "/\(result)"
        } else {
            // If somehow we're still here, a last gasp: the lowercased title without spaces.
            "/\(title.lowercased().replacing(" ", with: "-"))"
        }
    }
    
    /// Defaults to no sharing image
    var image: URL? { nil }
}
