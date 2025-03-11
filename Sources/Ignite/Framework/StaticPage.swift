//
// StaticPage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// One static page in your site, where the content is entirely standalone rather
/// than being produced in conjunction with an external Markdown file.
@MainActor
public protocol StaticPage: LayoutContent {
    /// All pages have a default path generated for them by Ignite, but you can
    /// override that here if you wish.
    var path: String { get }

    /// The title for this page.
    var title: String { get }

    /// The image for sharing the page
    var image: URL? { get }

    /// A plain-text description for this page. Defaults to an empty string.
    var description: String { get }
}

public extension StaticPage {
    /// A default description for this page, which is just an empty string.
    var description: String { "" }

    /// Auto-generates a path for this page using its Swift type name.
    var path: String {
        "/" + String(describing: Self.self).convertedToSlug()
    }

    /// Defaults to no sharing image
    var image: URL? { nil }
}
