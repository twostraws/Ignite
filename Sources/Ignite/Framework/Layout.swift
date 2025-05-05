//
// Layout.swift
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
///     var body: some Document {
///         Body {
///             content
///             Footer()
///         }
///     }
/// }
/// ```
@MainActor
public protocol Layout {
    /// The type of Document content this element contains.
    associatedtype Content: Document
    /// The main content of the layout.
    @DocumentBuilder var body: Content { get }
}

public extension Layout {
    /// The current page being rendered.
    var content: some HTML {
        Section(PublishingContext.shared.environment.pageContent)
            .class("ig-main-content")
    }
}
