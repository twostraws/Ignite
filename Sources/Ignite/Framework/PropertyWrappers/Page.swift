//
// Page.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A property wrapper that provides access to the current page being rendered.
///
/// Use the `@Page` property wrapper in your layouts to access information about the current page:
/// ```swift
/// struct ArticleLayout: Layout {
///     @Page private var page
///
///     var body: some HTML {
///         HTMLDocument {
///             HTMLHead(for: page)
///             HTMLBody {
///                 Article {
///                     Heading(page.title)
///                     Text(page.description)
///                 }
///             }
///         }
///     }
/// }
/// ```
/// > Important: This property wrapper is only valid in types that conform to `Layout`.
/// The page context is managed automatically by the publishing system during rendering.
@MainActor
@propertyWrapper
public struct Page {
    /// The current page being rendered.
    public var wrappedValue: HTMLPage {
        PageContext.current
    }

    /// Creates a new Page property wrapper.
    public init() {}
}
