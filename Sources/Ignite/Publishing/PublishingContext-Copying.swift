//
// PublishingContext-Copying.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Recursively copies or merges contents from a source directory to a destination directory.
    /// - For files: replaces existing files or creates new ones
    /// - For directories: creates if needed, then recursively merges contents
    /// - Parameters:
    ///   - source: The source URL to copy from
    ///   - destination: The destination URL to copy to
    private func mergeContents(from source: URL, to destination: URL) throws {
        let fileManager = FileManager.default

        var isDirectory: ObjCBool = false
        let sourceExists = fileManager.fileExists(atPath: source.path, isDirectory: &isDirectory)

        guard sourceExists else { return }

        if isDirectory.boolValue {
            // Source is a directory - create destination directory and merge contents
            try fileManager.createDirectory(at: destination, withIntermediateDirectories: true)

            let contents = try fileManager.contentsOfDirectory(
                at: source,
                includingPropertiesForKeys: nil
            )

            for item in contents {
                let itemName = item.lastPathComponent
                try mergeContents(
                    from: source.appending(path: itemName),
                    to: destination.appending(path: itemName)
                )
            }
        } else {
            // Source is a file - remove existing and copy
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            try fileManager.copyItem(at: source, to: destination)
        }
    }

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
            if FileManager.default.fileExists(atPath: destinationFile.path) {
                try FileManager.default.removeItem(at: destinationFile)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destinationFile)
        } catch {
            fatalError(.failedToCopySiteResource(resource))
        }
    }

    /// Copies all files from the project's "Assets" directory to the build output's root directory.
    /// Merges with any existing directories (e.g., css/, fonts/) that Ignite may have already created.
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
                try mergeContents(
                    from: assetsDirectory.appending(path: asset.lastPathComponent),
                    to: buildDirectory.appending(path: asset.lastPathComponent)
                )
            }
        } catch {
            fatalError(.failedToCopySiteResource("Assets"))
        }
    }

    /// Copies custom font files from the project's "Fonts" directory to the build output's "fonts" directory.
    /// Merges with any existing fonts that Ignite may have already created.
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
                try mergeContents(
                    from: fontsDirectory.appending(path: font.lastPathComponent),
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
