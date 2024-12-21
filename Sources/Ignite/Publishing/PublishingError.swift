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
public enum PublishingError: LocalizedError {
    /// Could not find the site's package directory.
    case missingPackageDirectory

    /// Could not find the app sandbox's home directory
    case missingSandboxHomeDirectory

    /// Invalid Markdown was found at the specific URL.
    case badMarkdown(URL)

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

    /// A syntax highlighter file resource could not be loaded.
    case failedToLoadSyntaxHighlighter(String)

    /// Publishing attempted to write out the syntax highlighter data during a
    /// build, but failed.
    case failedToWriteSyntaxHighlighters

    /// Publishing attempted to write out the RSS feed during a build, but failed.
    case failedToWriteFeed

    /// Publishing attempted to write out the robots.txt file during a build, but failed.
    case failedToWriteRobots

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
        case .failedToLoadSyntaxHighlighter(let name):
            "Failed to load syntax highlighter JavaScript: \(name)."
        case .failedToWriteSyntaxHighlighters:
            "Failed to write syntax highlighting JavaScript."
        case .failedToWriteFeed:
            "Failed to generate RSS feed."
        case .failedToWriteRobots:
            "Failed to write robots.txt file."
        case .missingNamedLayout(let name):
            "Failed to find layout named \(name)."
        case .missingDefaultLayout:
            "Your site must provide at least one layout in order to render Markdown."
        case .duplicateDirectory(let url):
            "Duplicate URL found: \(url). This is a fatal error."
        }
    }
}
