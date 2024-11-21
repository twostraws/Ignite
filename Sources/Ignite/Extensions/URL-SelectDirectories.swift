//
// URL-selectDirectories.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// Returns URL where to find Assets/Content/Includes and URL where to generate the static web site.
    /// - Parameter file: path of a Swift source file to find source root directory by scanning path upwards.
    /// - Returns tupple containing source URL and URL where output is built.
    public static func selectDirectories(from file: StaticString) throws -> SourceBuildDirectories {
        var currentURL = URL(filePath: file.description)

        while currentURL.path != "/" {
            currentURL = currentURL.deletingLastPathComponent()
            let packageURL = currentURL.appending(path: "Package.swift")

            if FileManager.default.fileExists(atPath: packageURL.path) {
                return SourceBuildDirectories(
                    source: packageURL.deletingLastPathComponent(),
                    build: packageURL.deletingLastPathComponent())
            }
        }

        throw PublishingError.missingPackageDirectory
    }
}

/// Provides URL to where to find Assets/Content/Includes input directories and Build output directory
public struct SourceBuildDirectories: Sendable {
    public let source: URL
    public let build: URL
}
