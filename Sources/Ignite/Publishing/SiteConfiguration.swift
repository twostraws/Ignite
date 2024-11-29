//
// SiteConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents metadata configuration for a website
public struct SiteConfiguration: Sendable {
    /// The author of the site
    public let author: String

    /// The name of the site
    public let name: String

    /// A string to append to the end of page titles
    public let titleSuffix: String

    /// An optional description for the site
    public let description: String?

    /// The language the site is published in
    public let language: Language

    /// The base URL for the site
    public let url: URL

    /// Configuration for loading Bootstrap resources
    public let useDefaultBootstrapURLs: BootstrapOptions

    /// Configuration for Bootstrap icons
    public let builtInIconsEnabled: BootstrapOptions

    /// Array of syntax highlighters enabled for the site
    public let syntaxHighlighters: [SyntaxHighlighter]

    /// The path to the favicon
    public let favicon: URL?

    /// Additional themes that can be selected by users beyond light and dark mode.
    public let alternateThemes: [any Theme]

    public init(
        author: String = "",
        name: String,
        titleSuffix: String = "",
        description: String? = nil,
        language: Language = .english,
        url: URL,
        useDefaultBootstrapURLs: BootstrapOptions = .localBootstrap,
        builtInIconsEnabled: BootstrapOptions = .localBootstrap,
        syntaxHighlighters: [SyntaxHighlighter] = [],
        favicon: URL? = nil,
        alternateThemes: [any Theme] = []
    ) {
        self.author = author
        self.name = name
        self.titleSuffix = titleSuffix
        self.description = description
        self.language = language
        self.url = url
        self.useDefaultBootstrapURLs = useDefaultBootstrapURLs
        self.builtInIconsEnabled = builtInIconsEnabled
        self.syntaxHighlighters = syntaxHighlighters
        self.favicon = favicon
        self.alternateThemes = alternateThemes
    }

    init() {
        self.author = ""
        self.name = ""
        self.titleSuffix = ""
        self.description = ""
        self.language = .english
        self.url = URL(static: "https://example.com")
        self.useDefaultBootstrapURLs = .localBootstrap
        self.builtInIconsEnabled = .localBootstrap
        self.syntaxHighlighters = []
        self.favicon = nil
        self.alternateThemes = []
    }
}
