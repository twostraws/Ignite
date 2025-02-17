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
    func copy(resource: String) {
        guard let sourceURL = Bundle.module.url(forResource: "Resources/\(resource)", withExtension: nil) else {
            fatalError(.missingSiteResource(resource))
        }

        let filename = sourceURL.lastPathComponent
        let destination = sourceURL.deletingLastPathComponent().lastPathComponent

        let destinationDirectory = buildDirectory.appending(path: destination)
        let destinationFile = destinationDirectory.appending(path: filename)

        do {
            try FileManager.default.createDirectory(at: destinationDirectory, withIntermediateDirectories: true)
            try FileManager.default.copyItem(at: sourceURL, to: destinationFile)
        } catch {
            fatalError(.failedToCopySiteResource(resource))
        }
    }

    /// Copies all files from the project's "Assets" directory to the build output's root directory.
    func copyAssets() {
        guard FileManager.default.fileExists(atPath: assetsDirectory.decodedPath) else {
            return
        }

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
            fatalError(.failedToCopySiteResource("Assets"))
        }
    }

    /// Copies custom font files from the project's "Fonts" directory to the build output's "fonts" directory.
    func copyFonts() {
        guard FileManager.default.fileExists(atPath: fontsDirectory.decodedPath) else {
            return
        }

        do {
            let fonts = try FileManager.default.contentsOfDirectory(
                at: fontsDirectory,
                includingPropertiesForKeys: nil
            )

            let buildFontsDirectory = buildDirectory.appending(path: "fonts")
            try FileManager.default.createDirectory(at: buildFontsDirectory, withIntermediateDirectories: true)

            for font in fonts {
                try FileManager.default.copyItem(
                    at: fontsDirectory.appending(path: font.lastPathComponent),
                    to: buildFontsDirectory.appending(path: font.lastPathComponent)
                )
            }
        } catch {
            fatalError(.failedToCopySiteResource("Fonts"))
        }
    }

    /// Calculates the full list of syntax highlighters need by this site, including
    /// resolving dependencies.
    func copySyntaxHighlighters() {
        let generator = SyntaxHighlightGenerator(site: site)
        let result = generator.generateSyntaxHighlighters(context: self)

        do {
            let destinationURL = buildDirectory.appending(path: "js/syntax-highlighting.js")
            try result.write(to: destinationURL, atomically: true, encoding: .utf8)
        } catch {
            fatalError(.failedToWriteSyntaxHighlighters)
        }

        for theme in site.allHighlighterThemes {
            copy(resource: theme.url)
        }
    }

}
