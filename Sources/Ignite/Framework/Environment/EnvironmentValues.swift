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
public struct EnvironmentValues {
    /// Provides access to the Markdown pages on this site.
    public var content: ContentLoader

    /// Configuration for RSS/Atom feed generation.
    public var feedConfiguration: FeedConfiguration?

    /// Available themes for the site, including light, dark, and any alternates.
    public var themes: [any Theme] = []

    /// Locates, loads, and decodes a JSON file in your Resources folder.
    public var decode: DecodeAction

    /// The site's metadata, such as name, description, and URL.
    public let site: SiteMetadata

    /// The author of the site
    public let author: String

    /// The language the site is published in
    public let language: Language

    /// The time zone used in date outputs.
    public let timeZone: TimeZone?

    /// The path to the favicon
    public let favicon: URL?

    /// Configuration for Bootstrap icons
    public let builtInIconsEnabled: BootstrapOptions

    /// The current page being rendered.
    var page: Page = .empty

    /// The current piece of Markdown content being rendered.
    var article: Content = .empty

    /// The current tag of the page being rendered.
    var tag: String?

    /// Content that has the current tag.
    var taggedContent: [Content] = []

    public init() {
        self.content = ContentLoader(content: [])
        self.feedConfiguration = FeedConfiguration(mode: .full, contentCount: 0)
        self.themes = []
        self.decode = .init(sourceDirectory: URL(filePath: ""))
        self.author = ""
        self.language = .english
        self.favicon = nil
        self.builtInIconsEnabled = .localBootstrap
        self.timeZone = .gmt
        self.site = .empty
    }

    init(sourceDirectory: URL, site: any Site, allContent: [Content]) {
        self.decode = DecodeAction(sourceDirectory: sourceDirectory)
        self.content = ContentLoader(content: allContent)
        self.feedConfiguration = site.feedConfiguration
        self.themes = site.allThemes
        self.author = site.author
        self.language = site.language
        self.favicon = site.favicon
        self.builtInIconsEnabled = site.builtInIconsEnabled
        self.timeZone = site.timeZone

        self.site = SiteMetadata(
            name: site.name,
            titleSuffix: site.titleSuffix,
            description: site.description,
            url: site.url)


    }

    init(sourceDirectory: URL, site: any Site, allContent: [Content], page: Page) {
        self.init(sourceDirectory: sourceDirectory, site: site, allContent: allContent)
        self.page = page
    }

    init(sourceDirectory: URL, site: any Site, allContent: [Content], article: Content) {
        self.init(sourceDirectory: sourceDirectory, site: site, allContent: allContent)
        self.article = article
    }

    init(sourceDirectory: URL, site: any Site, allContent: [Content], tag: String?, taggedContent: [Content]) {
        self.init(sourceDirectory: sourceDirectory, site: site, allContent: allContent)
        self.tag = tag
        self.taggedContent = taggedContent
    }
}
