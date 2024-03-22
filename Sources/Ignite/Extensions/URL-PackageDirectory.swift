//
// URL-PackageDirectory.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// Locates the source of a Swift package, regardless of how deep
    /// in a subfolder we currently are.
    public static func packageDirectory(from file: StaticString) throws -> URL {
        var currentURL = URL(filePath: file.description)

        repeat {
            currentURL = currentURL.deletingLastPathComponent()
            let packageURL = currentURL.appending(path: "Package.swift")

            if FileManager.default.fileExists(atPath: packageURL.path) {
                return packageURL.deletingLastPathComponent()
            }
        } while currentURL.path().isEmpty == false

        throw PublishingError.missingPackageDirectory
    }
}
