//
// StaticEnvironmentValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that stores global site settings available to use before the site is published.
@MainActor
public struct StaticEnvironmentValues {
    /// Provides access to the Markdown articles on this site.
    public var articles: ArticleLoader

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

    init(sourceDirectory: URL, site: any Site, allContent: [Article]) {
        self.decode = DecodeAction(sourceDirectory: sourceDirectory)
        self.articles = ArticleLoader(content: allContent)
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
}
