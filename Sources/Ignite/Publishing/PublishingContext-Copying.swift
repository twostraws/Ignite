//
// PublishingContext-Copying.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Copies one file from the Ignite resources into the final build folder.
    /// - Parameters resource: The resource to copy.
    func copy(resource: String) throws {
        guard let sourceURL = Bundle.module.url(forResource: "Resources/\(resource)", withExtension: nil) else {
            throw PublishingError.missingSiteResource(resource)
        }

        let filename = sourceURL.lastPathComponent
        let destination = sourceURL.deletingLastPathComponent().lastPathComponent

        let destinationDirectory = buildDirectory.appending(path: destination)
        let destinationFile = destinationDirectory.appending(path: filename)

        do {
            try FileManager.default.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)
            try FileManager.default.copyItem(at: sourceURL, to: destinationFile)
        } catch {
            throw PublishingError.failedToCopySiteResource(resource)
        }
    }

    /// Copies all files from the project's "Assets" directory to the build output's root directory.
    func copyAssets() throws {
        do {
            let assets = try FileManager.default.contentsOfDirectory(
                at: assetsDirectory,
                includingPropertiesForKeys: nil
            )

            for asset in assets {
                try FileManager.default.copyItem(
                    at: assetsDirectory.appending(path: asset.lastPathComponent),
                    to: buildDirectory.appending(path: asset.lastPathComponent)
                )
            }
        } catch {
            print("Could not copy assets from \(assetsDirectory) to \(buildDirectory): \(error).")
            throw error
        }
    }

    /// Copies custom font files from the project's "Fonts" directory to the build output's "fonts" directory.
    func copyFonts() throws {
        do {
            // Copy fonts if directory exists
            if FileManager.default.fileExists(atPath: fontsDirectory.path()) {
                let fonts = try FileManager.default.contentsOfDirectory(
                    at: fontsDirectory,
                    includingPropertiesForKeys: nil
                )

                let fontsDestDir = buildDirectory.appending(path: "fonts")
                try FileManager.default.createDirectory(at: fontsDestDir, withIntermediateDirectories: true)

                for font in fonts {
                    let destination = fontsDestDir.appending(path: font.lastPathComponent)
                    try FileManager.default.copyItem(at: font, to: destination)
                }
            }

            // Rest of the existing copyResources code...
        } catch {
            print("Could not copy assets from \(assetsDirectory) to \(buildDirectory): \(error).")
            throw error
        }
    }

    /// Calculates the full list of syntax highlighters need by this site, including
    /// resolving dependencies.
    func copySyntaxHighlighters() throws {
        for theme in site.allHighlighterThemes {
            try copy(resource: theme.url)
        }
    }

}
