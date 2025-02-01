//
// PublishingError.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// All the primary errors that can occur when publishing a site. There are other
/// errors that can be triggered, but they are handled through fatalError() because
/// something is seriously wrong.
extension String {
    /// Could not find the site's package directory.
    static let missingPackageDirectory = "Unable to locate Package.swift."

    /// Could not find the app sandbox's home directory
    static let missingSandboxHomeDirectory = "Unable to locate App sandbox's home directory"

    /// An incorrectly formatted date was found in a piece of Content.
    static let badContentDateFormat = "Content dates should be in the format 2024-05-24 15:30."

    /// Failed to embed theme-switching JavaScript in `HTMLHead`.
    static let failedToEmbedThemeSwitchingJS = "Failed to add theme-switching JavaScript to your site's <head>."

    /// The site lacks a default theme.
    static let missingDefaultTheme = "Ignite requires that you provide either a light or dark theme as the default."

    /// The site lacks a default syntax-highlighter theme.
    static let missingDefaultSyntaxHighlighterTheme = "At least one of your themes must specify a syntax highlighter."

    /// Publishing attempted to write out the syntax highlighter data during a build, but failed.
    static let failedToWriteSyntaxHighlighters = "Failed to write syntax highlighting JavaScript."

    /// Publishing attempted to write out the RSS feed during a build, but failed.
    static let failedToWriteFeed = "Failed to generate RSS feed."

    /// Site attempted to render Markdown content without a layout in place.
    static let missingDefaultLayout = "Your site must provide at least one layout in order to render Markdown."

    /// Invalid Markdown was found at the specific URL.
    static func badMarkdown(_ url: URL) -> String {
        "Markdown could not be parsed: \(url.absoluteString)."
    }

    /// A file cannot be opened (bad encoding, etc).
    static func unopenableFile(_ reason: String) -> String {
        "Failed to open file: \(reason)."
    }

    /// Publishing attempted to remove the build directory, but failed.
    static func failedToRemoveBuildDirectory(_ url: URL) -> String {
        "Failed to clear the build folder: \(url.absoluteString)."
    }

    /// Publishing attempted to create the build directory, but failed.
    static func failedToCreateBuildDirectory(_ url: URL) -> String {
        "Failed to create the build folder: \(url.absoluteString)."
    }

    /// Publishing attempted to create a file during a build, but failed.
    static func failedToCreateBuildFile(_ url: URL) -> String {
        "Failed to create the build folder: \(url.absoluteString)."
    }

    /// Failed to locate one of the key Ignite resources.
    static func missingSiteResource(_ name: String) -> String {
        "Failed to locate critical site resource: \(name)."
    }

    /// Publishing attempted to copy one of the key site resources during a build, but failed.
    static func failedToCopySiteResource(_ name: String) -> String {
        "Failed to copy critical site resource to build folder: \(name)."
    }

    /// A syntax highlighter file resource was not found.
    static func missingSyntaxHighlighter(_ name: String) -> String {
        "Failed to locate syntax highlighter JavaScript: \(name)."
    }

    /// A syntax highlighter file resource could not be loaded.
    static func failedToLoadSyntaxHighlighter(_ name: String) -> String {
        "Failed to load syntax highlighter JavaScript: \(name)."
    }

    /// Publishing attempted to write out a file during a build, but failed.
    static func failedToWriteFile(_ filename: String) -> String {
        "Failed to write \(filename) file."
    }

    /// A Markdown file requested a named layout that does not exist.
    static func missingNamedLayout(_ name: String) -> String {
        "Failed to find layout named \(name)."
    }

    /// Publishing attempted to write a file at the specific URL. but it already exists.
    static func duplicateDirectory(_ url: URL) -> String {
        "Duplicate URL found: \(url). This is a fatal error."
    }
}
