//
// Theme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Layouts allow you to have complete control over the HTML used to generate
/// your pages.
///
/// Example:
/// ```swift
/// struct BlogLayout: Layout {
///     var body: some HTML {
///         HTMLDocument {
///             Header("My Blog")
///             Body(for: page)
///             Footer()
///         }
///     }
/// }
/// ```
@MainActor
public protocol Layout {
    /// The type of HTML content this layout will generate
    associatedtype Markup: HTML

    /// The main content of the layout, built using the HTML DSL
    var body: Markup { get }

    /// A unique identifier for this layout instance
    var id: String { get }
}

public extension Layout {
    /// The current page being rendered.
    var page: Page {
        PageContext.current
    }

    /// Generates a unique identifier for this layout based on its file location and type.
    /// The identifier is used internally for tracking and caching purposes.
    var id: String {
        String(describing: self).truncatedHash
    }
}
