//
// PublishingError.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Unconditionally prints a given publishing error and stops execution.
/// - Parameter error: The error to print. The default is an empty string.
@inline(never)
func fatalError(_ error: PublishingError) -> Never {
    fatalError(error.errorDescription ?? "")
}

/// All the primary errors that can occur when publishing a site. There are other
/// errors that can be triggered, but they are handled through fatalError() because
/// something is seriously wrong.
enum PublishingError: LocalizedError {
    /// Could not find the site's package directory.
    case missingPackageDirectory

    /// Could not find the app sandbox's home directory
    case missingSandboxHomeDirectory

    /// Invalid Markdown was found at the specific URL.
    case badMarkdown(URL)

    /// An incorrectly formatted date was found in a piece of Content.
    case badContentDateFormat

    /// A file cannot be opened (bad encoding, etc).
    case unopenableFile(String)

    /// Publishing attempted to remove the build directory, but failed.
    case failedToRemoveBuildDirectory(URL)

    /// Publishing attempted to create the build directory, but failed.
    case failedToCreateBuildDirectory(URL)

    /// Publishing attempted to create a file during a build, but failed.
    case failedToCreateBuildFile(URL)

    /// Failed to locate one of the key Ignite resources.
    case missingSiteResource(String)

    /// Publishing attempted to copy one of the key site resources during a
    /// build, but failed.
    case failedToCopySiteResource(String)

    /// A syntax highlighter file resource was not found.
    case missingSyntaxHighlighter(String)

    /// Failed to embed theme-switching JavaScript in `HTMLHead`.
    case failedToEmbedThemeSwitchingJS

    /// The site lacks a default theme.
    case missingDefaultTheme

    /// The site lacks a default syntax-highlighter theme.
    case missingDefaultSyntaxHighlighterTheme

    /// A syntax highlighter file resource could not be loaded.
    case failedToLoadSyntaxHighlighter(String)

    /// Publishing attempted to write out the syntax highlighter data during a
    /// build, but failed.
    case failedToWriteSyntaxHighlighters

    /// Publishing attempted to write out the RSS feed during a build, but failed.
    case failedToWriteFeed

    /// Publishing attempted to write out a file during a build, but failed.
    case failedToWriteFile(String)

    /// A Markdown file requested a named layout that does not exist.
    case missingNamedLayout(String)

    /// Site attempted to render Markdown content without a layout in place.
    case missingDefaultLayout

    /// Publishing attempted to write a file at the specific URL. but it already exists.
    case duplicateDirectory(URL)

    /// Converts all errors to a string for easier reading.
    public var errorDescription: String? {
        switch self {
        case .missingPackageDirectory:
            "Unable to locate Package.swift."
        case .missingSandboxHomeDirectory:
            "Unable to locate App sandbox's home directory"
        case .badMarkdown(let url):
            "Markdown could not be parsed: \(url.absoluteString)."
        case .badContentDateFormat:
            "Content dates should be in the format 2024-05-24 15:30."
        case .unopenableFile(let reason):
            "Failed to open file: \(reason)."
        case .failedToRemoveBuildDirectory(let url):
            "Failed to clear the build folder: \(url.absoluteString)."
        case .failedToCreateBuildDirectory(let url):
            "Failed to create the build folder: \(url.absoluteString)."
        case .failedToCreateBuildFile(let url):
            "Failed to create the build folder: \(url.absoluteString)."
        case .missingSiteResource(let name):
            "Failed to locate critical site resource: \(name)."
        case .failedToCopySiteResource(let name):
            "Failed to copy critical site resource to build folder: \(name)."
        case .missingSyntaxHighlighter(let name):
            "Failed to locate syntax highlighter JavaScript: \(name)."
        case .failedToEmbedThemeSwitchingJS:
            "Failed to add theme-switching JavaScript to your site's <head>."
        case .missingDefaultTheme:
            "Ignite requires that you provide either a light or dark theme as the default."
        case .missingDefaultSyntaxHighlighterTheme:
            "At least one of your themes must specify a syntax highlighter."
        case .failedToLoadSyntaxHighlighter(let name):
            "Failed to load syntax highlighter JavaScript: \(name)."
        case .failedToWriteSyntaxHighlighters:
            "Failed to write syntax highlighting JavaScript."
        case .failedToWriteFeed:
            "Failed to generate RSS feed."
        case .failedToWriteFile(let filename):
            "Failed to write \(filename) file."
        case .missingNamedLayout(let name):
            "Failed to find layout named \(name)."
        case .missingDefaultLayout:
            "Your site must provide at least one layout in order to render Markdown."
        case .duplicateDirectory(let url):
            "Duplicate URL found: \(url). This is a fatal error."
        }
    }
}
