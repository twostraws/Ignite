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
    /// Provides access to all Markdown pages on this site.
    public var content: ContentLoader

    /// Configuration for RSS/Atom feed generation.
    public var feedConfiguration: FeedConfiguration

    /// Whether feed generation is enabled for the site.
    public var isFeedEnabled: Bool

    /// Available themes for the site, including light, dark, and any alternates.
    public var themes: [any Theme] = []

    /// Locates, loads, and decodes a JSON file in your Resources folder.
    public var decode: DecodeAction

    /// The name of the site
    public let siteName: String

    /// A string to append to the end of page titles
    public let siteTitleSuffix: String

    /// An optional description for the site
    public let siteDescription: String?

    /// The base URL for the site
    public let siteURL: URL

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

    public let pageTitle: String

    public let pageDescription: String

    public let pageURL: URL

    public let pageImage: URL?

    /// The current page being rendered.
    var pageContent: any HTML = EmptyHTML()

    /// The current Markdown content being rendered.
    var articleContent: Content = .empty

    /// The current tag for the page being rendered.
    var tag: String?

    /// All Markdown content with the current tag.
    var archiveContent = [Content]()

    public init() {
        self.content = ContentLoader(content: [])
        self.feedConfiguration = FeedConfiguration(mode: .full, contentCount: 0)
        self.isFeedEnabled = false
        self.themes = []
        self.decode = .init(sourceDirectory: URL(filePath: ""))
        self.author = ""
        self.siteName = ""
        self.siteTitleSuffix = ""
        self.siteDescription = nil
        self.language = .english
        self.siteURL = URL(static: "https://example.com")
        self.favicon = nil
        self.builtInIconsEnabled = .localBootstrap
        self.timeZone = .gmt
        self.pageTitle = ""
        self.pageDescription = ""
        self.pageURL = URL(static: "https://example.com")
        self.pageImage = nil
    }

    init(
        sourceDirectory: URL,
        site: any Site,
        allContent: [Content],
        pageTitle: String,
        pageDescription: String,
        pageURL: URL,
        pageImage: URL?,
        pageContent: any HTML
    ) {
        self.init(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            pageTitle: pageTitle,
            pageDescription: pageDescription,
            pageURL: pageURL,
            pageImage: pageImage)
        self.pageContent = pageContent
    }

    init(
        sourceDirectory: URL,
        site: any Site,
        allContent: [Content],
        pageTitle: String,
        pageDescription: String,
        pageURL: URL,
        pageImage: URL?,
        content: Content
    ) {
        self.init(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            pageTitle: pageTitle,
            pageDescription: pageDescription,
            pageURL: pageURL,
            pageImage: pageImage)
        self.articleContent = content
    }

    init(
        sourceDirectory: URL,
        site: any Site,
        allContent: [Content],
        pageTitle: String,
        pageDescription: String,
        pageURL: URL,
        tag: String?,
        archiveContent: [Content]
    ) {
        self.init(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            pageTitle: pageTitle,
            pageDescription: pageDescription,
            pageURL: pageURL,
            pageImage: nil)
        self.tag = tag
        self.archiveContent = archiveContent
    }

    init(
        sourceDirectory: URL,
        site: any Site,
        allContent: [Content],
        pageTitle: String,
        pageDescription: String,
        pageURL: URL,
        pageImage: URL?
    ) {
        self.decode = DecodeAction(sourceDirectory: sourceDirectory)
        self.content = ContentLoader(content: allContent)
        self.feedConfiguration = site.feedConfiguration
        self.isFeedEnabled = site.isFeedEnabled
        self.themes = site.allThemes
        self.author = site.author
        self.siteName = site.name
        self.siteTitleSuffix = site.titleSuffix
        self.siteDescription = site.description
        self.language = site.language
        self.siteURL = site.url
        self.favicon = site.favicon
        self.builtInIconsEnabled = site.builtInIconsEnabled
        self.timeZone = site.timeZone

        self.pageTitle = pageTitle
        self.pageDescription = pageDescription
        self.pageURL = pageURL
        self.pageImage = pageImage
    }
}
