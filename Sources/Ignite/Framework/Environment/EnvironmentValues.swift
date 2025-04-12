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
/// }
/// ```
@MainActor
public struct EnvironmentValues {
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

    /// The current page being rendered.
    internal(set) public var page: PageMetadata

    /// The content of the current page being rendered.
    var pageContent: any HTML = EmptyHTML()

    /// The current piece of Markdown content being rendered.
    var article: Article = .empty

    /// The current category of the page being rendered.
    var category: any Category = EmptyCategory()

    /// The current HTTP error of the page being rendered.
    var httpError: HTTPError = EmptyHTTPError()

    /// Content that has the current tag.
    var taggedContent: [Article] = []

    init() {
        self.articles = ArticleLoader(content: [])
        self.feedConfiguration = FeedConfiguration(mode: .full, contentCount: 0)
        self.themes = []
        self.decode = .init(sourceDirectory: URL(filePath: ""))
        self.author = ""
        self.language = .english
        self.favicon = nil
        self.builtInIconsEnabled = .localBootstrap
        self.timeZone = .gmt
        self.page = .empty
        self.site = .empty
    }

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
        self.page = .empty

        self.site = SiteMetadata(
            name: site.name,
            titleSuffix: site.titleSuffix,
            description: site.description,
            url: site.url)
    }

    init(
        sourceDirectory: URL,
        site: any Site,
        allContent: [Article],
        pageMetadata: PageMetadata,
        pageContent: any LayoutContent
    ) {
        self.decode = DecodeAction(sourceDirectory: sourceDirectory)
        self.articles = ArticleLoader(content: allContent)
        self.feedConfiguration = site.feedConfiguration
        self.themes = site.allThemes
        self.author = site.author
        self.language = site.language
        self.favicon = site.favicon
        self.builtInIconsEnabled = site.builtInIconsEnabled
        self.timeZone = site.timeZone
        self.page = pageMetadata

        self.site = SiteMetadata(
            name: site.name,
            titleSuffix: site.titleSuffix,
            description: site.description,
            url: site.url)

        self.pageContent = PublishingContext.shared.withEnvironment(self) {
            pageContent.body
        }
    }

    init(
        sourceDirectory: URL,
        site: any Site,
        allContent: [Article],
        pageMetadata: PageMetadata,
        pageContent: any LayoutContent,
        article: Article
    ) {
        self.decode = DecodeAction(sourceDirectory: sourceDirectory)
        self.articles = ArticleLoader(content: allContent)
        self.feedConfiguration = site.feedConfiguration
        self.themes = site.allThemes
        self.author = site.author
        self.language = site.language
        self.favicon = site.favicon
        self.builtInIconsEnabled = site.builtInIconsEnabled
        self.timeZone = site.timeZone
        self.page = pageMetadata

        self.site = SiteMetadata(
            name: site.name,
            titleSuffix: site.titleSuffix,
            description: site.description,
            url: site.url)

        self.article = article

        self.pageContent = PublishingContext.shared.withEnvironment(self) {
            pageContent.body
        }
    }

    init(
        sourceDirectory: URL,
        site: any Site,
        allContent: [Article],
        pageMetadata: PageMetadata,
        pageContent: any LayoutContent,
        category: any Category
    ) {
        self.decode = DecodeAction(sourceDirectory: sourceDirectory)
        self.articles = ArticleLoader(content: allContent)
        self.feedConfiguration = site.feedConfiguration
        self.themes = site.allThemes
        self.author = site.author
        self.language = site.language
        self.favicon = site.favicon
        self.builtInIconsEnabled = site.builtInIconsEnabled
        self.timeZone = site.timeZone
        self.page = pageMetadata

        self.site = SiteMetadata(
            name: site.name,
            titleSuffix: site.titleSuffix,
            description: site.description,
            url: site.url)

        self.category = category

        self.pageContent = PublishingContext.shared.withEnvironment(self) {
            pageContent.body
        }
    }
}
