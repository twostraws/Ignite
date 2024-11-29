//
// StaticPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One static layout in your site, where the content is entirely standalone rather
/// than being produced in conjunction with an external Markdown file.
@MainActor
public protocol StaticLayout: EnvironmentReader {
    /// All layouts have a default path generated for them by Ignite, but you can
    /// override that here if you wish.
    var path: String { get }

    /// The title for this layout.
    var title: String { get }

    /// The image for sharing the layout
    var image: URL? { get }

    /// A plain-text description for this layout. Defaults to an empty string.
    var description: String { get }

    /// The type of HTML content this element contains.
    associatedtype Body: HTML

    /// The content and behavior of this `HTML` element.
    @HTMLBuilder var body: Body { get }
}

public extension StaticLayout {
    /// A default description for this layout, which is just an empty string.
    var description: String { "" }

    /// Attempts to auto-generate a path for this layout using its name then title.
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
