//
// PublishingContext.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Publishing contexts manage the entire flow of publishing, through all
/// elements. This allows any part of the site to reference content, add
/// build warnings, and more.
@MainActor
public final class PublishingContext {
    /// The site that is currently being built.
    public var site: any Site

    /// The root directory for the user's website package.
    var sourceDirectory: URL

    /// The directory containing their custom assets.
    var assetsDirectory: URL

    /// The directory containing their custom fonts.
    var fontsDirectory: URL

    /// The directory containing their Markdown files.
    var contentDirectory: URL

    /// The directory containing includes to use with the `Include` element.
    var includesDirectory: URL

    /// The directory containing their final, built website.
    var buildDirectory: URL

    /// Path at which content renders. Defaults to nil.
    public var currentRenderingPath: String?

    /// Any warnings that have been issued during a build.
    private(set) var warnings = [String]()

    /// All the Markdown content this user has inside their Content folder.
    public private(set) var allContent = [Content]()

    /// The sitemap for this site. Yes, using an array is less efficient when
    /// using `contains()`, but it allows us to list pages in a sensible order.
    /// (Technically speaking the order doesn't matter, but if the order changed
    /// randomly every time a build took place it would be annoying for source
    /// control!)
    private(set) var siteMap = [Location]()

    /// Creates a new publishing context for a specific site, providing the path to
    /// one of the user's file. This then navigates upwards to find the root directory.
    /// - Parameters:
    ///   - site: The site we're currently publishing.
    ///   - file: One file from the user's package.
    ///   - buildDirectoryPath: The path where the artifacts are generated.
    ///   The default is "Build".
    init(for site: any Site, from file: StaticString, buildDirectoryPath: String = "Build") throws {
        self.site = site

        let sourceBuildDirectories = try URL.selectDirectories(from: file)
        sourceDirectory = sourceBuildDirectories.source
        buildDirectory = sourceBuildDirectories.build.appending(path: buildDirectoryPath)

        assetsDirectory = sourceDirectory.appending(path: "Assets")
        fontsDirectory = sourceDirectory.appending(path: "Fonts")
        contentDirectory = sourceDirectory.appending(path: "Content")
        includesDirectory = sourceDirectory.appending(path: "Includes")

        try parseContent()
    }

    /// Returns all content tagged with the specified tag, or all content if the tag is nil.
    /// - Parameter tag: The tag to filter by, or nil for all content.
    /// - Returns: An array of content matching the specified tag, or all content
    /// if no tag was specified.
    func content(tagged tag: String?) -> [Content] {
        if let tag {
            allContent.filter { $0.tags.contains(tag) }
        } else {
            allContent
        }
    }

    /// Adds a warning during a site build.
    /// - Parameter message: The warning string to add.
    func addWarning(_ message: String) {
        if warnings.contains(message) == false {
            warnings.append(message)
        }
    }

    /// Adds one path to the sitemap.
    /// - Parameters:
    ///   - path: The path to add.
    ///   - priority: The priority for this path, in the range of 0 (least important)
    ///   to 1 (most important).
    func addToSiteMap(_ path: String, priority: Double) {
        siteMap.append(Location(path: path, priority: priority))
    }

    /// Parses all Markdown content in the site's Content folder.
    func parseContent() throws {
        guard let enumerator = FileManager.default.enumerator(
            at: contentDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey, .creationDateKey]
        ) else {
            return
        }

        while let objectURL = enumerator.nextObject() as? URL {
            guard objectURL.hasDirectoryPath == false else { continue }

            if objectURL.pathExtension == "md" {
                let values = try objectURL.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])

                let article = try Content(from: objectURL, in: self, resourceValues: values)

                if article.isPublished {
                    allContent.append(article)
                }
            }
        }
    }

    /// Performs all steps required to publish a site.
    func publish() async throws {
        try clearBuildFolder()
        try await generateContent()
        try copyResources()
        try generateThemes(site.alternateThemes)
        generateAnimations()
        try await generateTagPages()
        try generateSiteMap()
        try generateFeed()
        try generateRobots()
    }

    /// Removes all content from the Build folder, so we're okay to recreate it.
    func clearBuildFolder() throws {
        do {
            // Apple's docs for fileExists() recommend _not_ to check existence and then make change to file system
            try FileManager.default.removeItem(at: buildDirectory)
        } catch {
            print("Could not remove buildDirectory (\(buildDirectory)), but it will be re-created anyway.")
        }

        do {
            try FileManager.default.createDirectory(at: buildDirectory, withIntermediateDirectories: true)
        } catch {
            throw PublishingError.failedToCreateBuildDirectory(buildDirectory)
        }
    }

    /// Copies the key resources for building: user assets, Bootstrap JavaScript
    /// and CSS, icons CSS and fonts if enabled, and syntax highlighters
    /// if enabled.
    func copyResources() throws {
        try copyAssets()
        try copyFonts()

        if !FileManager.default.fileExists(atPath: buildDirectory.appending(path: "css/themes.min.css").path()) {
            try copy(resource: "css/themes.min.css")
        }

        if AnimationManager.default.hasAnimations {
            if !FileManager.default.fileExists(atPath: buildDirectory.appending(path: "css/animations.min.css").path()) {
                try copy(resource: "css/animations.min.css")
            }
        }

        try copy(resource: "js/ignite-core.js")

        if site.useDefaultBootstrapURLs == .localBootstrap {
            try copy(resource: "css/bootstrap.min.css")
            try copy(resource: "js/bootstrap.bundle.min.js")
        }

        if site.builtInIconsEnabled == .localBootstrap {
            try copy(resource: "css/bootstrap-icons.min.css")
            try copy(resource: "fonts/bootstrap-icons.woff")
            try copy(resource: "fonts/bootstrap-icons.woff2")
        }

        if site.syntaxHighlighters.isEmpty == false {
            try copySyntaxHighlighters()
            try copy(resource: "css/prism-default-dark.css")
        }
    }

    /// Writes a single string of data to a URL.
    /// - Parameters:
    ///   - string: The string to write.
    ///   - directory: The directory to write to. This has "index.html"
    ///   appended to it, so users are directed to the correct page immediately.
    ///   - priority: A priority value to control how important this content
    ///   is for the sitemap.
    func write(_ string: String, to directory: URL, priority: Double) throws {
        let relativePath = directory.relative(to: buildDirectory)

        if siteMap.contains(relativePath) {
            throw PublishingError.duplicateDirectory(directory)
        }

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        } catch {
            throw PublishingError.failedToCreateBuildDirectory(directory)
        }

        let outputURL = directory.appending(path: "index.html")

        do {
            try string.write(to: outputURL, atomically: true, encoding: .utf8)
            addToSiteMap(relativePath, priority: priority)
        } catch {
            throw PublishingError.failedToCreateBuildFile(outputURL)
        }
    }

    /// Renders one page using the correct theme, which is taken either from the
    /// provided them or from the main site theme.
    func render(_ page: Page) -> String {
        PageContext.withCurrentPage(page) {
            let values = EnvironmentValues(sourceDirectory: sourceDirectory, site: site, allContent: allContent)
            return EnvironmentStore.update(values) {
                site.layout.body.render(context: self)
            }
        }
    }

    /// Renders a static page.
    /// - Parameters:
    ///   - page: The page to render.
    ///   - isHomePage: True if this is your site's homepage; this affects the
    ///   final path that is written to.
    func render(_ staticPage: any StaticLayout, isHomePage: Bool = false) throws {
        let path = isHomePage ? "" : staticPage.path

        let page = Page(
            title: staticPage.title,
            description: staticPage.description,
            url: site.url.appending(path: path),
            image: staticPage.image,
            body: staticPage.body
        )

        currentRenderingPath = isHomePage ? "/" : staticPage.path

        let outputString = render(page)
        let outputDirectory = buildDirectory.appending(path: path)
        try write(outputString, to: outputDirectory, priority: isHomePage ? 1 : 0.9)
    }

    /// Renders one piece of Markdown content.
    /// - Parameter content: The content to render.
    func render(_ content: Content) throws {
        let body = ContentContext.withCurrentContent(content) {
            Group(context: self, items: [content.body])
        }

        currentRenderingPath = content.path

        let page = Page(
            title: content.title,
            description: content.description,
            url: site.url.appending(path: content.path),
            image: content.image.flatMap { URL(string: $0) },
            body: body
        )

        let outputString = render(page)
        let outputDirectory = buildDirectory.appending(path: content.path)
        try write(outputString, to: outputDirectory, priority: 0.8)
    }

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
    private func copyAssets() throws {
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
    private func copyFonts() throws {
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
        let generator = SyntaxHighlightGenerator(site: site)
        let result = try generator.generateSyntaxHighlighters()

        do {
            let destinationURL = buildDirectory.appending(path: "js/syntax-highlighting.js")
            try result.write(to: destinationURL, atomically: true, encoding: .utf8)
        } catch {
            throw PublishingError.failedToWriteSyntaxHighlighters
        }
    }
}
