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
public protocol Layout {
    /// The type of markup content this layout contains.
    associatedtype Content: MarkupElement
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

extension Layout {
    /// Renders this layout as a complete document.
    func documentMarkupString() -> String {
        let content = documentContent()
        return PlainDocument(head: content.head, body: content.body).markupString()
    }

    /// Resolves this layout to document head and body content.
    func documentContent() -> (head: Head, body: Body) {
        let body = body

        return if let document = body as? any Document {
            (document.head, document.body)
        } else if let body = body as? Body {
            (Head(), body)
        } else if let html = body as? any HTML {
            (Head(), Body {
                AnyHTML(html)
            })
        } else {
            fatalError("Layouts must return Document, Body, or HTML content.")
        }
    }
}
