//
// PublishingContext.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import SwiftSoup

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

    /// An ordered set of syntax highlighters you want to enable for your site.
    var highlighterLanguages = OrderedSet<HighlighterLanguage>()

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
        try generateThemes(site.allThemes)
        try generateMediaQueryCSS()
        generateAnimations()
        try await generateTagLayouts()
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

        if !FileManager.default.fileExists(atPath: buildDirectory.appending(path: "css/themes.min.css").path(percentEncoded: false)) {
            try copy(resource: "css/themes.min.css")
        }

        if AnimationManager.default.hasAnimations {
            let animationsPath = buildDirectory.appending(path: "css/animations.min.css").path()
            if !FileManager.default.fileExists(atPath: animationsPath) {
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

        if highlighterLanguages.isEmpty == false {
            try copy(resource: "js/prism-core.js")
            try copySyntaxHighlighters()
        }
    }

    /// Formats HTML content with proper indentation and line breaks, returning original HTML if formatting fails.
    private func prettifyHTML(_ html: String) -> String {
        do {
            let doc = try SwiftSoup.parse(html)
            doc.outputSettings()
                .prettyPrint(pretty: true)
                .indentAmount(indentAmount: 2)
            return try doc.outerHtml()
        } catch {
            addWarning("HTML could not be prettified: \(error.localizedDescription).")
            return html
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
        var html = string

        if site.prettifyHTML {
            html = prettifyHTML(string)
        }

        do {
            try html.write(to: outputURL, atomically: true, encoding: .utf8)
            addToSiteMap(relativePath, priority: priority)
        } catch {
            throw PublishingError.failedToCreateBuildFile(outputURL)
        }
    }

    /// Renders one static page using the correct theme, which is taken either from the
    /// provided them or from the main site theme.
    func render(_ page: Page, using layout: any Layout) -> String {
        let finalLayout: any Layout

        if layout is MissingLayout {
            finalLayout = site.layout
        } else {
            finalLayout = layout
        }

        return PageContext.withCurrentPage(page) {
            let values = EnvironmentValues(sourceDirectory: sourceDirectory, site: site, allContent: allContent)
            return EnvironmentStore.update(values) {
                finalLayout.body.render(context: self)
            }
        }
    }

    /// Renders a static page.
    /// - Parameters:
    ///   - page: The page to render.
    ///   - isHomePage: True if this is your site's homepage; this affects the
    ///   final path that is written to.
    func render(_ staticLayout: any StaticLayout, isHomePage: Bool = false) throws {
        let path = isHomePage ? "" : staticLayout.path
        currentRenderingPath = isHomePage ? "/" : staticLayout.path

        let values = EnvironmentValues(sourceDirectory: sourceDirectory, site: site, allContent: allContent)
        let body = EnvironmentStore.update(values) {
            staticLayout.body
        }

        let page = Page(
            title: staticLayout.title,
            description: staticLayout.description,
            url: site.url.appending(path: path),
            image: staticLayout.image,
            body: body
        )

        let outputString = render(page, using: staticLayout.parentLayout)
        let outputDirectory = buildDirectory.appending(path: path)
        try write(outputString, to: outputDirectory, priority: isHomePage ? 1 : 0.9)
    }

    /// Renders one piece of Markdown content.
    /// - Parameter content: The content to render.
    func render(_ content: Content) throws {
        let layout = try layout(for: content)

        let body = ContentContext.withCurrentContent(content) {
            Section(context: self, items: [layout.body])
        }

        currentRenderingPath = content.path

        let page = Page(
            title: content.title,
            description: content.description,
            url: site.url.appending(path: content.path),
            image: content.image.flatMap { URL(string: $0) },
            body: body
        )

        let outputString = render(page, using: layout.parentLayout)
        let outputDirectory = buildDirectory.appending(path: content.path)
        try write(outputString, to: outputDirectory, priority: 0.8)
    }

    /// Locates the best layout to use for a piece of Markdown content. Layouts
    /// are specified using YAML front matter, but if none are found then the first
    /// layout in your site's `layouts` property is used.
    /// - Parameter content: The content that is being rendered.
    /// - Returns: The correct `ContentPage` instance to use for this content.
    func layout(for content: Content) throws -> any ContentLayout {
        if let contentLayout = content.layout {
            for layout in site.contentLayouts {
                let layoutName = String(describing: type(of: layout))

                if layoutName == contentLayout {
                    return layout
                }
            }

            throw PublishingError.missingNamedLayout(contentLayout)
        } else if let defaultLayout = site.contentLayouts.first {
            return defaultLayout
        } else {
            throw PublishingError.missingDefaultLayout
        }
    }
}
