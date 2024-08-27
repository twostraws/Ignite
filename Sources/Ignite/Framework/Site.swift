//
// Site.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Describes one site being generated by Ignite.
public protocol Site {
    /// The type of your homepage. Required.
    associatedtype HomePageType: StaticPage

    /// The type used to generate your tag pages. A default is provided that means
    /// no tags pages are generated.
    associatedtype TagPageType: TagPage

    /// The theme for your site. Required.
    associatedtype ThemeType: Theme

    /// The Markdown parser to use for Content pages.
    associatedtype MarkdownRendererType: MarkdownRenderer

    /// A robots.txt configuration for your site. A default is provided that means
    /// all robots can index all pages.
    associatedtype RobotsType: RobotsConfiguration

    /// The author of your site, which should be your name.
    /// Defaults to an empty string.
    var author: String { get }

    /// A string to append to the end of your page titles. For example, if you have
    /// a page titled "About Me" and a site title suffix of " – My Awesome Site", then
    /// your rendered page title will be "About Me – My Awesome Site".
    /// Defaults to an empty string.
    var titleSuffix: String { get }

    /// The name of your site. Required.
    var name: String { get }

    /// An optional description for your site. Defaults to nil.
    var description: String? { get }

    /// The language your site is published in. Defaults to `.en`.
    var language: Language { get }

    /// The base URL for your site, e.g. https://www.example.com
    var url: URL { get }

    /// How wide your page should be on desktop web browsers. Defaults to 10,
    /// which allows a little margin on either side.
    var pageWidth: Int { get }

    /// Set to true if you want to use the Bootstrap icon collection on your site.
    /// Visit https://icons.getbootstrap.com for the full list.
    var builtInIconsEnabled: Bool { get }

    /// An array of syntax highlighters you want to enable for your site.
    var syntaxHighlighters: [SyntaxHighlighter] { get }

    /// The Markdown renderer to use for content in this site. Note: This
    /// only applies to content pages rendered from the Content folder;
    /// the standard MarkdownToHTML parser is used for `Text` and
    /// other built-in elements regardless of the setting here.
    var markdownRenderer: MarkdownRendererType.Type { get }

    /// Controls how the RSS feed for your site should be generated. The default
    /// configuration sends back content description only for 20 items.
    var feedConfiguration: FeedConfiguration { get }

    /// Controls how search engines and similar index your site. The default
    /// configuration allows all robots to index everything.
    var robotsConfiguration: RobotsType { get }

    /// The homepage for your site; what users land on when visiting your root domain.
    var homePage: HomePageType { get }

    /// A type that conforms to `TagPage`, to be used when rendering individual
    /// tag pages or the "all tags" page.
    var tagPage: TagPageType { get }

    /// The theme to apply to your site. This is used to render all pages that don't
    /// explicitly override the theme with something custom.
    var theme: ThemeType { get }

    /// The color mode to apply to the site, default is light mode
    var colorScheme: ColorScheme { get }

    /// The path to the favicon
    var favicon: URL? { get }

    /// An array of all the static pages you want to include in your site.
    @StaticPageBuilder var pages: [any StaticPage] { get }

    /// An array of all the content layouts you want to include in your site.
    @ContentPageBuilder var layouts: [any ContentPage] { get }

    /// Publishes this entire site from user space.
    func publish(from file: StaticString, buildDirectoryPath: String) async throws
}

extension Site {
    /// No default author.
    public var author: String { "" }

    /// No default title suffix.
    public var titleSuffix: String { "" }

    /// No default description.
    public var description: String? { nil }

    /// English as default language.
    public var language: Language { .english }

    /// Use 10 of the 12 available columns by default. Only applies to
    /// desktop browsers where horizontal space is plentiful.
    public var pageWidth: Int { 10 }

    /// Disable Bootstrap icons by default.
    public var builtInIconsEnabled: Bool { false }

    /// Include no syntax highlighters by default.
    public var syntaxHighlighters: [SyntaxHighlighter] { [] }

    /// Use the standard MarkdownToHTML renderer by default.
    public var markdownRenderer: MarkdownToHTML.Type {
        MarkdownToHTML.self
    }

    /// A default feed configuration allows 20 items of content, showing just
    /// their descriptions.
    public var feedConfiguration: FeedConfiguration { .default }

    /// A simple helper property that determines whether we have a feed
    /// configuration that means a feed should actually be made.
    public var isFeedEnabled: Bool {
        feedConfiguration.mode != .disabled && feedConfiguration.contentCount > 0
    }

    /// A default robots.txt configuration that allows all robots to index all pages.
    public var robotsConfiguration: DefaultRobotsConfiguration { DefaultRobotsConfiguration() }

    /// No static pages by default.
    public var pages: [any StaticPage] { [] }

    /// No content pages by default.
    public var layouts: [any ContentPage] { [] }

    /// An empty tag page by default, which triggers no tag pages being made.
    public var tagPage: EmptyTagPage { EmptyTagPage() }

    /// The default color mode being light
    public var colorScheme: ColorScheme { .light }

    /// The default favicon being nil
    public var favicon: URL? { nil }

    /// Performs the entire publishing flow from a file in user space, e.g. main.swift
    /// or Site.swift.
    /// - Parameters:
    ///   - file: The file that triggered the build. This is used to
    ///   locate the base directory for their project, so we can location key folders.
    ///   - buildDirectoryPath: This path will generate the necessary artifacts for the web page. Please modify as needed.
    ///   The default is "Build".
    public func publish(from file: StaticString = #file, buildDirectoryPath: String = "Build") async throws {
        let context = try PublishingContext(for: self, from: file, buildDirectoryPath: buildDirectoryPath)
        try await context.publish()

        if context.warnings.isEmpty == false {
            print("Publish completed with warnings:")
            print(context.warnings.map { "\t- \($0)" }.joined(separator: "\n"))
        }
    }
}
