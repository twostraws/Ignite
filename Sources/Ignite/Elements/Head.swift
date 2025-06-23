//
// HTMLHead.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A group of metadata headers for your page, such as its title,
/// links to its CSS, and more.
public struct Head: MarkupElement {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Whether to include standard headers and social sharing tags
    private var includeStandardHeaders = true

    /// The metadata elements for this page.
    private var items: [any HeadElement]

    /// The default target for links in this document.
    private var defaultLinkTarget: LinkTarget?

    /// Creates a new `Head` instance using an element builder that returns
    /// an array of `HeadElement` objects.
    /// - Parameter items: The `HeadElement` items you want to
    /// include for this page.
    public init(@HeadElementBuilder items: () -> [any HeadElement] = { [] }) {
        self.items = items()
    }

    /// Disables the inclusion of standard headers and social sharing tags.
    /// - Returns: A new Head instance with standard headers disabled
    public func standardHeadersDisabled() -> Head {
        var copy = self
        copy.includeStandardHeaders = false
        return copy
    }

    /// Sets the default target for all links in the document.
    /// - Parameter target: The `LinkTarget` to use as the default for all links.
    /// - Returns: A new `Head` instance with the specified base target.
    public func defaultLinkTarget(_ target: LinkTarget) -> Self {
        var copy = self
        copy.defaultLinkTarget = target
        return copy
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> Markup {
        var items = items
        if includeStandardHeaders {
            items.insert(contentsOf: MetaTag.socialSharingTags(), at: 0)
            items.insert(contentsOf: Head.standardHeaders(), at: 0)
        }

        var contentHTML = items.map { $0.markupString() }
        if let defaultLinkTarget, let name = defaultLinkTarget.name {
            contentHTML.insert("<base target=\"\(name)\" />", at: 0)
        }

        return Markup("<head\(attributes)>\(contentHTML.joined())</head>")
    }

    /// Returns the standard set of headers used for a `Page` instance.
    @HeadElementBuilder static func standardHeaders() -> [any HeadElement] {
        MetaTag.utf8
        MetaTag.flexibleViewport

        let environment = PublishingContext.shared.environment
        let pageDescription = environment.page.description

        if pageDescription.isEmpty == false {
            MetaTag(name: "description", content: pageDescription)
        }

        let context = PublishingContext.shared
        let site = context.site

        if site.author.isEmpty == false {
            MetaTag(name: "author", content: site.author)
        }

        MetaTag.generator

        Title(environment.page.title)

        if site.useDefaultBootstrapURLs == .localBootstrap {
            MetaLink.standardCSS
        } else if site.useDefaultBootstrapURLs == .remoteBootstrap {
            MetaLink.standardRemoteCSS
        }

        if context.hasSyntaxHighlighters, site.allHighlighterThemes.isEmpty == false {
            MetaLink.highlighterThemeMetaLinks(for: site.allHighlighterThemes)
            MetaLink.prismPluginCSS
        }

        if site.builtInIconsEnabled == .localBootstrap {
            MetaLink.iconCSS
        } else if site.builtInIconsEnabled == .remoteBootstrap {
            MetaLink.remoteIconCSS
        }

        MetaLink.igniteCoreCSS

        MetaLink(href: environment.page.url, rel: "canonical")

        if let favicon = site.favicon {
            MetaLink(href: favicon, rel: .icon)
        }

        if site.allThemes.count > 1, let themeSwitchingScript {
            themeSwitchingScript
        }
    }

    /// An inline script that handles theme changes immediately.
    private static var themeSwitchingScript: Script? {
        guard let sourceURL = Bundle.module.url(forResource: "Resources/js/theme-switching", withExtension: "js"),
              let contents = try? String(contentsOf: sourceURL)
        else {
            PublishingContext.shared.addError(.missingSiteResource("js/theme-switching.js"))
            return nil
        }
        return Script(code: contents)
    }
}
