//
// URL-selectDirectories.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// Returns URL where to find Assets/Content/Includes and URL where to generate the static web site.
    /// For now both URLs always equal:
    ///     * A standalone Ignite package doesn't generate a container/sandbox to hold the app's output website.
    ///     * Ignite as a package in a regular app cannot read or write to the source location (sandbox/security).
    /// In both cases, ensure that Assets/Content/Include data can be found at buildDirectoryURL.
    /// - Parameter file: path of a Swift source file to find source root directory by scanning path upwards.
    /// - Returns struct containing source URL and URL where output is built.
    public static func selectDirectories(from file: StaticString) throws -> SourceAndBuildDirectories {
        var currentURL = URL(filePath: file.description)

        // try to see if we are building a standalone package (and can thus find Package.swift somewhere in path))
        repeat {
            currentURL = currentURL.deletingLastPathComponent()

            let packageURL = currentURL.appending(path: "Package.swift")
            if FileManager.default.fileExists(atPath: packageURL.path) {
                return SourceAndBuildDirectories(source: packageURL.deletingLastPathComponent(),
                                                 build: packageURL.deletingLastPathComponent())
            }
        } while currentURL.path() !=  "/"

        // assume we are building a sandboxed app that uses Ignite as a regular package
        let buildDirectoryString = NSHomeDirectory() // app's home directory for a sandboxed MacOS app
        let buildDirectoryURL = URL(filePath: buildDirectoryString)
        let sourceDirectoryURL = buildDirectoryURL // has to contain any Assets/Content/Includes

        guard buildDirectory.contains("/Library/Containers/") else {
            throw PublishingError.missingPackageDirectory // actually
        }

        return SourceAndBuildDirectories(source: sourceDirectoryURL,
                                         build: buildDirectoryURL)
    }

}

/// Provides URL to where to find Assets/Content/Includes input directories and Build output directory
public struct SourceAndBuildDirectories {
    public let source: URL
    public let build: URL
}
