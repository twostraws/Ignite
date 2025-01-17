//
// Head.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

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
    ///   - context: The active `PublishingContext`, which includes
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
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "head"
        return attributes.description(wrapping: HTMLCollection(items).render(context: context))
    }

    /// A static function, returning the standard set of headers used for a `Page` instance.
    ///
    /// This function can be used when defining a custom header based on the standard set of headers.
    /// - Parameters:
    ///   - page: The `Page` you want to create headers for.
    ///   - context: The active `PublishingContext`, which includes
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

        if configuration.hasMultipleThemes {
            themeSwitchingScript
        }
    }

    /// An inline script that handles theme changes immediately.
    private static var themeSwitchingScript: Script {
        Script(code: """
        (function() {
            function getThemePreference() {
                return localStorage.getItem('custom-theme') || 'auto';
            }

            function applyTheme(themeID) {
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                const lightThemeID = document.documentElement.getAttribute('data-light-theme') || 'light';
                const darkThemeID = document.documentElement.getAttribute('data-dark-theme') || 'dark';
                const actualThemeID = themeID === 'auto' ? (prefersDark ? darkThemeID : lightThemeID) : themeID;
                
                document.documentElement.setAttribute('data-bs-theme', actualThemeID);
                document.documentElement.setAttribute('data-theme-state', themeID);
            }

            function applySyntaxTheme() {
                const syntaxTheme = getComputedStyle(document.documentElement)
                    .getPropertyValue('--syntax-highlight-theme').trim().replace(/"/g, '');

                if (!syntaxTheme) return;

                document.querySelectorAll('link[data-highlight-theme]').forEach(link => {
                    link.setAttribute('disabled', 'disabled');
                });

                const themeLink = document.querySelector(`link[data-highlight-theme="${syntaxTheme}"]`);
                if (themeLink) {
                    themeLink.removeAttribute('disabled');
                }
            }

            window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', e => {
                const currentTheme = getThemePreference();
                if (currentTheme === 'auto') {
                    applyTheme('auto');
                    applySyntaxTheme();
                }
            });

            const savedTheme = getThemePreference();
            applyTheme(savedTheme);
            applySyntaxTheme();
        })();
        """)
    }
}
