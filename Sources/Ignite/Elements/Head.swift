//
// HTMLHead.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A group of metadata headers for your page, such as its title,
/// links to its CSS, and more.
public struct Head: RootElement {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// Whether to include standard headers and social sharing tags
    private var includeStandardHeaders = true

    /// The metadata elements for this page.
    var items: [any HeadElement]

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

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var items = items
        if includeStandardHeaders {
            items.insert(contentsOf:  MetaTag.socialSharingTags(), at: 0)
            items.insert(contentsOf: Head.standardHeaders(), at: 0)
        }

        var attributes = attributes
        attributes.tag = "head"
        return attributes.description(wrapping: HTMLCollection(items).render())
    }

    /// A static function, returning the standard set of headers used for a `Page` instance.
    ///
    /// This function can be used when defining a custom header based on the standard set of headers.
    @HeadElementBuilder
    public static func standardHeaders() -> [any HeadElement] {
        // swiftlint:disable:previous cyclomatic_complexity
        MetaTag.utf8
        MetaTag.flexibleViewport

        let environment = PublishingContext.default.environment
        let pageDescription = environment.pageDescription

        if pageDescription.isEmpty == false {
            MetaTag(name: "description", content: pageDescription)
        }

        let context = PublishingContext.default
        let site = context.site

        if site.author.isEmpty == false {
            MetaTag(name: "author", content: site.author)
        }

        MetaTag.generator

        Title(environment.pageTitle)

        if site.useDefaultBootstrapURLs == .localBootstrap {
            MetaLink.standardCSS
        } else if site.useDefaultBootstrapURLs == .remoteBootstrap {
            MetaLink.remoteIconCSS
        }

        if context.hasSyntaxHighlighters, site.allHighlighterThemes.isEmpty == false {
            MetaLink.highlighterThemeMetaLinks(for: site.allHighlighterThemes)
        }

        if site.builtInIconsEnabled == .localBootstrap {
            MetaLink.iconCSS
        } else if site.builtInIconsEnabled == .remoteBootstrap {
            MetaLink.remoteIconCSS
        }

        if AnimationManager.default.hasAnimations {
            MetaLink.animationCSS
        }

        MetaLink.themeCSS

        if CSSManager.default.hasCSS {
            MetaLink.mediaQueryCSS
        }

        MetaLink(href: environment.pageURL, rel: "canonical")

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
            PublishingContext.default.addError(.missingSiteResource("js/theme-switching.js"))
            return nil
        }
        return Script(code: contents)
    }
}
