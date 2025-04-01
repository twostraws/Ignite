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
    private static var sharedContext: PublishingContext!

    /// The shared instance of `PublishingContext`.
    static var shared: PublishingContext {
        guard let sharedContext else {
            fatalError("""
            "PublishingContext.default accessed before being initialized. \
            Call PublishingContext.initialize() first.
            """)
        }

        return sharedContext
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

    /// The current environment values for the application.
    var environment = EnvironmentValues()

    /// All the Markdown content this user has inside their Content folder.
    private(set) var allContent = [Article]()

    /// An ordered set of syntax highlighters pulled from code blocks throughout the site.
    var syntaxHighlighters = OrderedSet<HighlighterLanguage>()

    /// Whether the site uses syntax highlighters.
    var hasSyntaxHighlighters: Bool {
        !syntaxHighlighters.isEmpty || !site.syntaxHighlighterConfiguration.languages.isEmpty
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

        try parseContent()
    }

    /// Creates and sets the shared instance of `PublishingContext`
    /// - Parameters:
    ///   - site: The site we're currently publishing.
    ///   - file: One file from the user's package.
    ///   - buildDirectoryPath: The path where the artifacts are generated.
    ///   The default is "Build".
    /// - Returns: The shared `PublishingContext` instance.
    @discardableResult
    static func initialize(
        for site: any Site,
        from file: StaticString,
        buildDirectoryPath: String = "Build"
    ) throws -> PublishingContext {
        let context = try PublishingContext(for: site, from: file, buildDirectoryPath: buildDirectoryPath)
        sharedContext = context
        return context
    }

    /// Returns all content tagged with the specified tag, or all content if the tag is nil.
    /// - Parameter tag: The tag to filter by, or nil for all content.
    /// - Returns: An array of content matching the specified tag, or all content
    /// if no tag was specified.
    func content(tagged tag: String?) -> [Article] {
        if let tag {
            allContent.filter { $0.tags?.contains(tag) == true }
        } else {
            allContent
        }
    }

    /// Converts a URL to a site-relative path string.
    /// - Parameter url: The URL to convert.
    /// - Returns: A string path, either preserving remote URLs or
    /// making local URLs relative to the site root.
    func path(for url: URL) -> String {
        let path = url.relativeString
        return if url.isFileURL {
            site.url.appending(path: path).decodedPath
        } else {
            path
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
        try ContentFinder.shared.find(root: contentDirectory) { deploy in
            let article = try Article(
                from: deploy.url,
                in: self,
                resourceValues: deploy.resourceValues,
                deployPath: deploy.path
            )
            if article.isPublished {
                allContent.append(article)
            }
            return true // always continuing
        }

        // Make content be sorted newest first by default.
        allContent.sort(
            by: \.date,
            order: .reverse
        )
    }

    /// Performs all steps required to publish a site.
    func publish() async throws {
        clearBuildFolder()
        await generateContent()
        copyResources()
        generateThemes(site.allThemes)
        generateMediaQueryCSS()
        generateAnimations()
        generateSiteMap()
        generateFeed()
        generateRobots()
    }

    /// Removes all content from the Build folder, so we're okay to recreate it.
    func clearBuildFolder() {
        // Apple's docs for fileExists() recommend _not_ to check
        // existence and then make change to the file system, so we
        // just try our best and silently fail.
        try? FileManager.default.removeItem(at: buildDirectory)

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

        let igniteCorePath = buildDirectory.appending(path: "css/ignite-core.min.css").decodedPath

        if !FileManager.default.fileExists(atPath: igniteCorePath) {
            copy(resource: "css/ignite-core.min.css")
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
            copy(resource: "css/prism-plugins.css")
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
    ///   - directory: The directory to write to. This has "<filename>.html"
    ///   appended to it, so users are directed to the correct page immediately.
    ///   - priority: A priority value to control how important this content
    ///   is for the sitemap.
    ///   - filename: The filename to use. Defaults to "index". Do not include the MIME type.
    func write(_ string: String, to directory: URL, priority: Double?, filename: String = "index") {
        let relativePath = directory.relative(to: buildDirectory)

        if relativePath != "/" && siteMap.contains(relativePath) {
            errors.append(PublishingError.duplicateDirectory(directory))
        }

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        } catch {
            errors.append(PublishingError.failedToCreateBuildDirectory(directory))
        }

        let outputURL = directory.appending(path: filename.appending(".html"))
        var html = string

        if site.prettifyHTML {
            html = prettifyHTML(string)
        }

        do {
            try html.write(to: outputURL, atomically: true, encoding: .utf8)
            if let priority {
                addToSiteMap(relativePath, priority: priority)
            }
        } catch {
            errors.append(PublishingError.failedToCreateBuildFile(outputURL))
        }
    }

    /// Temporarily updates the environment values for the duration of an operation.
    /// - Parameters:
    ///   - environment: The new environment values to use
    ///   - operation: A closure that executes with the temporary environment
    /// - Returns: The value returned by the operation
    func withEnvironment<T>(_ environment: EnvironmentValues, operation: () -> T) -> T {
        let previous = self.environment
        self.environment = environment
        defer { self.environment = previous }
        return operation()
    }
}
