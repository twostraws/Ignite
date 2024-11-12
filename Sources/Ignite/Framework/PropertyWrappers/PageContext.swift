//
// PageContext.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Manages the current page context during HTML rendering.
/// This class provides a way to temporarily set the current page
/// while rendering HTML elements that need access to page-level information.
@MainActor
final class PageContext: Sendable {
    /// The current page being rendered. Defaults to an empty page.
    static var current: HTMLPage = .empty

    /// Temporarily sets a new current page for the duration of an operation.
    /// - Parameters:
    ///   - page: The page to set as current
    ///   - operation: The work to perform while the page is set as current
    /// - Returns: The result of the operation
    static func withCurrentPage<T>(_ page: HTMLPage, operation: () throws -> T) rethrows -> T {
        let previous = current
        current = page
        defer { current = previous }
        return try operation()
    }
}

private extension HTMLPage {
    /// Creates an empty page for use as a default value
    @MainActor static let empty = HTMLPage(
        title: "",
        description: "",
        url: URL(string: "about:blank")!,
        body: EmptyHTML()
    )
}
