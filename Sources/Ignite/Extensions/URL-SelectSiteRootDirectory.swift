//
// URL-SelectSiteRootDirectory.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension URL {
    /// Locates the source of a Swift package, regardless of how deep
    /// in a subfolder we currently are.
    public static func selectSiteRootDirectory(from file: StaticString) throws -> URL {
        var currentURL = URL(filePath: file.description)

        repeat {
            currentURL = currentURL.deletingLastPathComponent()

            let packageURL = currentURL.appending(path: "Package.swift")
            if FileManager.default.fileExists(atPath: packageURL.path) {
                return packageURL.deletingLastPathComponent()
            }
        } while currentURL.path() !=  "/"

        let homeDir: String = NSHomeDirectory() // on a sandboxed MacOS app, this is the app's home directory
        if homeDir.contains("/Library/Containers/") {
            do {
                return try URL("file://" + homeDir, strategy: .url)
            } catch {
                throw PublishingError.missingSandboxHomeDirectory
            }
        }

        throw PublishingError.missingPackageDirectory
    }

}
