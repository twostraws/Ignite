//
// Head.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A group of metadata headers for your page, such as its title,
/// links to its CSS, and more.
public struct Head: HTMLRootElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// The metadata elements for this page.
    var items: [HeadElement]

    /// Creates a new `Head` instance using an element builder that returns
    /// an array of `HeadElement` objects.
    /// - Parameter items: The `HeadElement` items you want to
    /// include for this page.
    public init(@HeadElementBuilder items: () -> [HeadElement]) {
        self.items = items()
    }

    /// A convenience initializer that creates a standard set of headers to use
    /// for a `Page` instance.
    /// - Parameters:
    ///   - page: The `Page` you want to create headers for.
    ///   - context: The active `PublishingContext`, which includes
    ///   information about the site being rendered and more.
    public init(for page: Page, in context: PublishingContext) {
        self.init {
            MetaTag.utf8
            MetaTag.flexibleViewport

            if page.description.isEmpty == false {
                MetaTag(name: "description", content: page.description)
            }

            if context.site.author.isEmpty == false {
                MetaTag(name: "author", content: context.site.author)
            }

            MetaTag.generator

            Title(page.title)

            MetaLink.standardCSS

            if context.site.syntaxHighlighters.isEmpty == false {
                MetaLink.syntaxHighlightingCSS
            }

            if context.site.builtInIconsEnabled {
                MetaLink.iconCSS
            }

            MetaLink(href: page.url, rel: "canonical")
            
            if let favicon = context.site.favicon {
                MetaLink(href: favicon, rel: .icon)
            }
        }

        items += MetaTag.socialSharingTags(for: page, context: context)
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        "<head>\(items.render(context: context))</head>"
    }
}
