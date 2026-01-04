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

    /// Creates source/build directories from explicit URLs.
    /// Use this when embedding Ignite in an app target where Package.swift doesn't exist.
    /// - Parameters:
    ///   - source: The root directory containing Assets, Content, and Includes folders.
    ///   - build: The directory where the generated site will be written.
    /// - Returns: A `SourceBuildDirectories` instance with the provided directories.
    /// - Throws: `PublishingError.missingSourceDirectory` if the source directory doesn't exist
    ///   or is not a directory.
    public static func makeDirectories(
        source: URL,
        build: URL
    ) throws -> SourceBuildDirectories {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: source.path, isDirectory: &isDirectory)
        guard exists, isDirectory.boolValue else {
            throw PublishingError.missingSourceDirectory(source)
        }
        return SourceBuildDirectories(source: source, build: build)
    }
}

/// Provides URL to where to find Assets/Content/Includes input directories and Build output directory
public struct SourceBuildDirectories: Sendable {
    public let source: URL
    public let build: URL
}
