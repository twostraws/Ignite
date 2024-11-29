//
// Theme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Layouts allow you to have complete control over the HTML used to generate
/// your pages.
///
/// Example:
/// ```swift
/// struct BlogLayout: Layout {
///     var body: some HTML {
///         HTMLDocument {
///             Header("My Blog")
///             HTMLBody(for: page)
///             Footer()
///         }
///     }
/// }
/// ```
@MainActor
public protocol Layout: Sendable {
    /// The type of HTML content this layout will generate
    associatedtype Body: HTML

    /// The main content of the layout, built using the HTML DSL
    var body: Body { get }

    /// A unique identifier for this layout instance
    var id: String { get set }
}

public extension Layout {
    /// The current page being rendered.
    var page: Page {
        PageContext.current
    }

    /// Generates a unique identifier for this layout based on its file location and type.
    /// The identifier is used internally for tracking and caching purposes.
    var id: String {
        get {
            String(describing: self).truncatedHash
        }
        set {}
    }
}
