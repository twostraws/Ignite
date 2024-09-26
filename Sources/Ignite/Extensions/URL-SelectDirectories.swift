//
// URL-selectDirectories.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// Returns URL where to find Assets/Content/Includes and URL where to generate the static web site.
    /// When building a package, the website is built at the source URL (and both URLs are equal).
    /// When building a MacOS app, the website is built in a subdirectory of the app's sandbox.
    /// - Parameter file: path of a Swift source file to find source root directory by scanning path upwards.
    /// - Returns tupple containing source URL and URL where output is built.
    public static func selectDirectories(from file: StaticString) throws -> SourceBuildDirectories {
        var currentURL = URL(filePath: file.description)

        repeat {
            currentURL = currentURL.deletingLastPathComponent()

            let packageURL = currentURL.appending(path: "Package.swift")
            if FileManager.default.fileExists(atPath: packageURL.path) {
                return SourceBuildDirectories(source: packageURL.deletingLastPathComponent(),
                                              build: packageURL.deletingLastPathComponent())
            }
        } while currentURL.path() !=  "/"

        let buildDirectory: String = NSHomeDirectory() // app's home directory for a sandboxed MacOS app
        if buildDirectory.contains("/Library/Containers/") {
            let buildDirectoryURL: URL = URL(filePath: buildDirectory)
            return SourceBuildDirectories(source: buildDirectoryURL,
                                          build: buildDirectoryURL)
        }

        throw PublishingError.missingPackageDirectory
    }

}

/// Provides URL to where to find Assets/Content/Includes input directories and Build output directory
public struct SourceBuildDirectories {
    public let source: URL
    public let build: URL
}
