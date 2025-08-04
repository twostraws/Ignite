//
// Document.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines an HTML document.
/// - Warning: Do not conform to this protocol directly.
@MainActor
public protocol Document {
    /// The main content section of the document.
    var body: Body { get }

    /// The metadata section of the document.
    var head: Head { get }

    /// Renders the document as markup.
    /// - Returns: The rendered markup representation.
    func render() -> Markup
}

extension Document {
    /// Converts this element and its children into an HTML string with attributes.
    /// - Returns: A string containing the HTML markup
    func markupString() -> String {
        render().string
    }

    /// The publishing context of this site.
    var publishingContext: PublishingContext {
        PublishingContext.shared
    }

    /// Returns the appropriate theme attributes on the document
    /// root element based on the site's theme configuration.
    var themeAttribute: Attribute? {
        let site = publishingContext.site

        guard !site.hasMultipleThemes else {
            return nil
        }

        return if site.lightTheme != nil {
            .init(name: "bs-theme", value: "light")
        } else if site.darkTheme != nil {
            .init(name: "bs-theme", value: "dark")
        } else {
            nil
        }
    }
}
