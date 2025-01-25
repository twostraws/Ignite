//
// Head.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A group of metadata headers for your page, such as its title,
/// links to its CSS, and more.
public struct HTMLHead: RootHTML {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// The metadata elements for this page.
    var items: [any HeadElement]

    /// Creates a new `Head` instance using an element builder that returns
    /// an array of `HeadElement` objects.
    /// - Parameter items: The `HeadElement` items you want to
    /// include for this page.
    public init(@HeadElementBuilder items: () -> [any HeadElement]) {
        self.items = items()
    }

    /// A convenience initializer that creates a standard set of headers to use
    /// for a `Page` instance.
    /// - Parameters:
    ///   - page: The `Page` you want to create headers for.
    ///   - configuration: The `SiteConfiguration`, which includes
    ///   information about the site being rendered and more.
    ///   - additionalItems: Additional items to enhance the set of standard headers.
    public init(
        for page: Page,
        with configuration: SiteConfiguration,
        @HeadElementBuilder additionalItems: () -> [any HeadElement] = { [] }
    ) {
        items = HTMLHead.standardHeaders(for: page, with: configuration)
        items += MetaTag.socialSharingTags(for: page, with: configuration)
        items += additionalItems()
    }

    /// Renders this element using publishing context passed in.
    /// - Returns: The HTML for this element.
    public func render() -> String {
        var attributes = attributes
        attributes.tag = "head"
        return attributes.description(wrapping: HTMLCollection(items).render())
    }

    /// A static function, returning the standard set of headers used for a `Page` instance.
    ///
    /// This function can be used when defining a custom header based on the standard set of headers.
    /// - Parameters:
    ///   - page: The `Page` you want to create headers for.
    ///   - configuration: The active `SiteConfiguration`, which includes
    ///   information about the site being rendered and more.
    @HeadElementBuilder
    public static func standardHeaders(for page: Page, with configuration: SiteConfiguration) -> [any HeadElement] {
        MetaTag.utf8
        MetaTag.flexibleViewport

        if page.description.isEmpty == false {
            MetaTag(name: "description", content: page.description)
        }

        if configuration.author.isEmpty == false {
            MetaTag(name: "author", content: configuration.author)
        }

        MetaTag.generator

        Title(page.title)

        if configuration.useDefaultBootstrapURLs == .localBootstrap {
            MetaLink.standardCSS
        } else if configuration.useDefaultBootstrapURLs == .remoteBootstrap {
            MetaLink.remoteIconCSS
        }

        if configuration.highlighterThemes.isEmpty == false {
            MetaLink.highlighterThemeMetaLinks(for: configuration.highlighterThemes)
        }

        if configuration.builtInIconsEnabled == .localBootstrap {
            MetaLink.iconCSS
        } else if configuration.builtInIconsEnabled == .remoteBootstrap {
            MetaLink.remoteIconCSS
        }

        if AnimationManager.default.hasAnimations {
            MetaLink.animationCSS
        }

        MetaLink.themeCSS
        MetaLink.mediaQueryCSS

        MetaLink(href: page.url, rel: "canonical")

        if let favicon = configuration.favicon {
            MetaLink(href: favicon, rel: .icon)
        }

        if configuration.hasMultipleThemes, let themeSwitchingScript {
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

public extension HTMLHead {
    /// The type of HTML this element returns after attributes have been applied.
    typealias AttributedHTML = Self

    func id(_ id: String) -> Self {
        attributes.id(id, persistentID: self.id)
        return self
    }

    @discardableResult func `class`(_ classes: String...) -> Self {
        attributes.classes(classes, persistentID: id)
        return self
    }

    func aria(_ key: AriaType, _ value: String) -> Self {
        attributes.aria(key, value, persistentID: id)
        return self
    }

    func data(_ name: String, _ value: String) -> Self {
        attributes.data(name, value, persistentID: id)
        return self
    }

    @discardableResult func style(_ property: Property, _ value: String) -> Self {
        attributes.style(property, value, persistentID: id)
        return self
    }
}
