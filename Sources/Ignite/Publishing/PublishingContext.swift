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
final class PublishingContext {
    /// The shared instance of `PublishingContext`.
    private static var defaultContext: PublishingContext!

    /// The shared instance of `PublishingContext`.
    static var `default`: PublishingContext {
        guard let defaultContext else {
            fatalError("""
            "PublishingContext.default accessed before being initialized. \
            Call PublishingContext.initialize() first.
            """)
        }

        return defaultContext
    }

    /// The site that is currently being built.
    var site: any Site

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
    private(set) var warnings = OrderedSet<String>()

    /// Any errors that have been issued during a build.
    private(set) var errors = [PublishingError]()

    /// All the Markdown content this user has inside their Content folder.
    public private(set) var allContent = [Content]()

    /// An ordered set of syntax highlighters pulled from code blocks throughout the site.
    var syntaxHighlighters = OrderedSet<HighlighterLanguage>()

    /// Whether the site uses syntax highlighters.
    var hasSyntaxHighlighters: Bool {
        !syntaxHighlighters.isEmpty || !site.syntaxHighlighters.isEmpty
    }

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
    private init(for site: any Site, from file: StaticString, buildDirectoryPath: String = "Build") throws {
        self.site = site

        let sourceBuildDirectories = try URL.selectDirectories(from: file)
        sourceDirectory = sourceBuildDirectories.source
        buildDirectory = sourceBuildDirectories.build.appending(path: buildDirectoryPath)

        assetsDirectory = sourceDirectory.appending(path: "Assets")
        fontsDirectory = sourceDirectory.appending(path: "Fonts")
        contentDirectory = sourceDirectory.appending(path: "Content")
        includesDirectory = sourceDirectory.appending(path: "Includes")
    }

    /// Creates and sets the shared instance of `PublishingContext`
    /// - Parameters:
    ///   - site: The site we're currently publishing.
    ///   - file: One file from the user's package.
    ///   - buildDirectoryPath: The path where the artifacts are generated.
    ///   The default is "Build".
    /// - Returns: The shared `PublishingContext` instance.
    @discardableResult
    public static func initialize(
        for site: any Site,
        from file: StaticString,
        buildDirectoryPath: String = "Build"
    ) throws -> PublishingContext {
        let context = try PublishingContext(for: site, from: file, buildDirectoryPath: buildDirectoryPath)
        defaultContext = context
        return context
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
        warnings.append(message)
    }

    /// Adds an error during a site build.
    /// - Parameter error: The error to add.
    func addError(_ error: PublishingError) {
        errors.append(error)
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

                let article = try Content(from: objectURL, resourceValues: values)

                if article.isPublished {
                    allContent.append(article)
                }
            }
        }

        // Make content be sorted newest first by default.
        allContent.sort(
            by: \.date,
            order: .reverse
        )
    }

    /// Performs all steps required to publish a site.
    func publish() async throws {
        try parseContent()
        clearBuildFolder()
        await generateContent()
        copyResources()
        generateThemes(site.allThemes)
        generateMediaQueryCSS()
        generateAnimations()
        await generateArchivePages()
        generateSiteMap()
        generateFeed()
        generateRobots()
    }

    /// Removes all content from the Build folder, so we're okay to recreate it.
    func clearBuildFolder() {
        do {
            // Apple's docs for fileExists() recommend _not_ to check existence and then make change to file system
            try FileManager.default.removeItem(at: buildDirectory)
        } catch {
            print("Could not remove buildDirectory (\(buildDirectory)), but it will be re-created anyway.")
        }

        do {
            try FileManager.default.createDirectory(at: buildDirectory, withIntermediateDirectories: true)
        } catch {
            fatalError(.failedToCreateBuildDirectory(buildDirectory))
        }
    }

    /// Copies the key resources for building: user assets, Bootstrap JavaScript
    /// and CSS, icons CSS and fonts if enabled, and syntax highlighters
    /// if enabled.
    func copyResources() {
        copyAssets()
        copyFonts()

        let themesPath = buildDirectory.appending(path: "css/themes.min.css").decodedPath

        if !FileManager.default.fileExists(atPath: themesPath) {
            copy(resource: "css/themes.min.css")
        }

        if AnimationManager.default.hasAnimations {
            let animationsPath = buildDirectory.appending(path: "css/animations.min.css").decodedPath
            if !FileManager.default.fileExists(atPath: animationsPath) {
                copy(resource: "css/animations.min.css")
            }
        }

        copy(resource: "js/ignite-core.js")

        if site.useDefaultBootstrapURLs == .localBootstrap {
            copy(resource: "css/bootstrap.min.css")
            copy(resource: "js/bootstrap.bundle.min.js")
        }

        if site.builtInIconsEnabled == .localBootstrap {
            copy(resource: "css/bootstrap-icons.min.css")
            copy(resource: "fonts/bootstrap-icons.woff")
            copy(resource: "fonts/bootstrap-icons.woff2")
        }

        if hasSyntaxHighlighters {
            copy(resource: "js/prism-core.js")
            copySyntaxHighlighters()
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
    func write(_ string: String, to directory: URL, priority: Double) {
        let relativePath = directory.relative(to: buildDirectory)

        if siteMap.contains(relativePath) {
            errors.append(PublishingError.duplicateDirectory(directory))
        }

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        } catch {
            errors.append(PublishingError.failedToCreateBuildDirectory(directory))
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
            errors.append(PublishingError.failedToCreateBuildFile(outputURL))
        }
    }

    /// Renders a static page.
    /// - Parameters:
    ///   - page: The page to render.
    ///   - isHomePage: True if this is your site's homepage; this affects the
    ///   final path that is written to.
    func render(_ page: any Page, isHomePage: Bool = false) {
        let path = isHomePage ? "" : page.path
        currentRenderingPath = isHomePage ? "/" : page.path

        let values = EnvironmentValues(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            pageTitle: page.title,
            pageDescription: page.description,
            pageURL: site.url.appending(path: path),
            pageImage: page.image,
            pageContent: page)

        let finalLayout: any Layout = page.layout is MissingLayout ? site.layout : page.layout

        let outputString = EnvironmentStore.update(values) {
            finalLayout.body.render()
        }

        let outputDirectory = buildDirectory.appending(path: path)
        write(outputString, to: outputDirectory, priority: isHomePage ? 1 : 0.9)
    }

    /// Renders one piece of Markdown content.
    /// - Parameter content: The content to render.
    func render(_ content: Content) {
        let article = layout(for: content)

        currentRenderingPath = content.path

        let values = EnvironmentValues(
            sourceDirectory: sourceDirectory,
            site: site,
            allContent: allContent,
            pageTitle: content.title,
            pageDescription: content.description,
            pageURL: site.url.appending(path: content.path),
            pageImage: content.image.flatMap { URL(string: $0) },
            pageContent: article,
            content: content)

        let finalLayout: any Layout = article.layout is MissingLayout ? site.layout : article.layout

        let outputString = EnvironmentStore.update(values) {
            finalLayout.body.render()
        }

        let outputDirectory = buildDirectory.appending(path: content.path)
        write(outputString, to: outputDirectory, priority: 0.8)
    }

    /// Locates the best layout to use for a piece of Markdown content. Layouts
    /// are specified using YAML front matter, but if none are found then the first
    /// layout in your site's `layouts` property is used.
    /// - Parameter content: The content that is being rendered.
    /// - Returns: The correct `ContentPage` instance to use for this content.
    func layout(for content: Content) -> any Article {
        if let contentLayout = content.layout {
            for layout in site.articles {
                let layoutName = String(describing: type(of: layout))

                if layoutName == contentLayout {
                    return layout
                }
            }

            fatalError(.missingNamedLayout(contentLayout))
        } else if let defaultLayout = site.articles.first {
            return defaultLayout
        } else {
            fatalError(.missingDefaultLayout)
        }
    }
}
