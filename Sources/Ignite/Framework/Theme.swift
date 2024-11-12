//
// Theme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Themes allow you to have complete control over the HTML used to generate
/// your pages.
///
/// Example:
/// ```swift
/// struct BlogLayout: Theme {
///     @Page private var page
///
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
public protocol Theme: Sendable {
    /// The type of HTML content this layout will generate
    associatedtype Body: HTML

    /// The main content of the layout, built using the HTML DSL
    var body: Body { get }

    /// A unique identifier for this layout instance
    var id: String { get set }
}

public extension Theme {
    /// Generates a unique identifier for this layout based on its file location and type.
    /// The identifier is used internally for tracking and caching purposes.
    var id: String {
        get {
            let location = #filePath + #line.description
            let description = String(describing: self)
            return (location + description).truncatedHash
        }
        set {}
    }
}

extension Theme {
    /// Renders the layout with the given page content in the current publishing context.
    /// - Parameters:
    ///   - page: The page content to render within this layout
    ///   - context: The current publishing context containing site-wide settings and content
    /// - Returns: The rendered HTML string
    func render(page: HTMLPage, context: PublishingContext) -> String {
        context.render(page: page) { body.render(context: context) }
    }
}
