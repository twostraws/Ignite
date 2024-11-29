//
// EnvironmentValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that stores global configuration and Layout settings for your site.
///
/// Environment values are propagated through your site's view hierarchy and can be accessed
/// using the `@Environment` property wrapper. For example:
///
/// ```swift
/// struct ContentView: HTMLRootElement {
///     @Environment(\.themes) var themes
///     @Environment(\.siteConfiguration) var config
/// }
/// ```
@MainActor
public struct EnvironmentValues: Sendable {
    /// All markdown content pages in the site.
    public var allContent: [Content]

    /// Configuration for RSS/Atom feed generation.
    public var feedConfiguration: FeedConfiguration

    /// Whether feed generation is enabled for the site.
    public var isFeedEnabled: Bool

    /// Available themes for the site, including light, dark, and any alternates.
    public var themes: [any Theme] = []

    /// Global site configuration settings.
    public var siteConfiguration: SiteConfiguration

    /// Locates, loads, and decodes a JSON file in your Resources folder.
    public var decode: DecodeAction

    /// Creates environment values with default settings.
    public init() {
        self.allContent = []
        self.feedConfiguration = FeedConfiguration(mode: .full, contentCount: 0)
        self.isFeedEnabled = false
        self.themes = []
        self.siteConfiguration = SiteConfiguration()
        self.decode = .init(sourceDirectory: URL(filePath: ""))
    }

    init(sourceDirectory: URL, site: any Site, allContent: [Content]) {
        self.decode = DecodeAction(sourceDirectory: sourceDirectory)
        self.allContent = allContent
        self.feedConfiguration = site.feedConfiguration
        self.isFeedEnabled = site.isFeedEnabled
        if let lightTheme = site.lightTheme {
            self.themes.append(lightTheme)
        }
        if let darkTheme = site.darkTheme {
            self.themes.append(darkTheme)
        }
        if site.darkTheme != nil && site.lightTheme != nil {
            self.themes.append(AutoTheme())
        }
        self.themes.append(contentsOf: site.alternateThemes)

        // Initialize metadata with all head-related configuration
        self.siteConfiguration = SiteConfiguration(
            author: site.author,
            name: site.name,
            titleSuffix: site.titleSuffix,
            description: site.description,
            language: site.language,
            url: site.url,
            useDefaultBootstrapURLs: site.useDefaultBootstrapURLs,
            builtInIconsEnabled: site.builtInIconsEnabled,
            syntaxHighlighters: site.syntaxHighlighters,
            favicon: site.favicon
        )
    }
}
