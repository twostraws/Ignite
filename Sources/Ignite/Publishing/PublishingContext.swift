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
public class PublishingContext {
    /// The site that is currently being built.
    public var site: any Site

    /// The root directory for the user's website package.
    var rootDirectory: URL

    /// The directory containing their custom assets.
    var assetsDirectory: URL

    /// The directory containing their Markdown files.
    var contentDirectory: URL

    /// The directory containing includes to use with the `Include` element.
    var includesDirectory: URL

    /// The directory containing their final, built website.
    var buildDirectory: URL

    /// Any warnings that have been issued during a build.
    private(set) var warnings = [String]()

    /// All the Markdown content this user has inside their Content folder.
    private(set) public var allContent = [Content]()

    /// The sitemap for this site. Yes, using an array is less efficient when
    /// using `contains()`, but it allows us to list pages in a sensible order.
    /// (Technically speaking the order doesn't matter, but if the order changed
    /// randomly every time a build took place it would be annoying for source
    /// control!)
    private(set) var siteMap = [Location]()

    /// Creates a new publishing context for a specific site, setting a root URL.
    /// - Parameters:
    ///   - site: The site we're currently publishing.
    ///   - rootURL: The URL of the root directory, where other key
    ///   folders are located.
    ///   - buildDirectoryPath: The path where the artifacts are generated.
    ///   The default is "Build".
    init(for site: any Site, rootURL: URL, buildDirectoryPath: String = "Build") throws {
        self.site = site

        self.rootDirectory = rootURL
        assetsDirectory = rootDirectory.appending(path: "Assets")
        contentDirectory = rootDirectory.appending(path: "Content")
        includesDirectory = rootDirectory.appending(path: "Includes")
        buildDirectory = rootDirectory.appending(path: buildDirectoryPath)

        try parseContent()
    }

    /// Creates a new publishing context for a specific site, providing the path to
    /// one of the user's file. This then navigates upwards to find the root directory.
    /// - Parameters:
    ///   - site: The site we're currently publishing.
    ///   - file: One file from the user's package.
    ///   - buildDirectoryPath: The path where the artifacts are generated.
    ///   The default is "Build".
    init(for site: any Site, from file: StaticString, buildDirectoryPath: String = "Build") throws {
        self.site = site

        rootDirectory = try URL.packageDirectory(from: file)
        assetsDirectory = rootDirectory.appending(path: "Assets")
        contentDirectory = rootDirectory.appending(path: "Content")
        includesDirectory = rootDirectory.appending(path: "Includes")
        buildDirectory = rootDirectory.appending(path: buildDirectoryPath)

        try parseContent()
    }

    /// Returns all content tagged with the specified tag, or all content if the tag is nil.
    /// - Parameter tag: The tag to filter by, or nil for all content.
    /// - Returns: An array of content matching the specified tag, or all content
    /// if no tag was specified.
    public func content(tagged tag: String?) -> [Content] {
        if let tag {
            allContent.filter { $0.tags.contains(tag) }
        } else {
            allContent
        }
    }

    /// Returns all content tagged with the specified type, or all content if the type is nil.
    /// - Parameter type: The type to filter by, or nil for all content.
    /// - Returns: An array of content matching the specified type, or all content
    /// if no type was specified.
    public func content(ofType type: String?) -> [Content] {
        if let type {
            allContent.filter { $0.type == type }
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

                let article = try Content(from: objectURL, relativeTo: contentDirectory, resourceValues: values)

                if article.isPublished {
                    allContent.append(article)
                }
            }
        }
    }

    /// Performs all steps required to publish a site.
    func publish() throws {
        try clearBuildFolder()
        try copyResources()
        try generateContent()
        try generateTagPages()
        try generateSiteMap()
        try generateFeed()
        try generateRobots()
    }

    /// Removes all content from the Build folder, so we're okay to recreate it.
    func clearBuildFolder() throws {
        if FileManager.default.fileExists(atPath: buildDirectory.path()) {
            do {
                try FileManager.default.removeItem(at: buildDirectory)
            } catch {
                throw PublishingError.failedToRemoveBuildDirectory(buildDirectory)
            }
        }

        do {
            try FileManager.default.createDirectory(at: buildDirectory, withIntermediateDirectories: false)
        } catch {
            throw PublishingError.failedToCreateBuildDirectory(buildDirectory)
        }
    }

    /// Copies the key resources for building: user assets, Bootstrap JavaScript
    /// and CSS, icons CSS and fonts if enabled, and syntax highlighters
    /// if enabled.
    func copyResources() throws {
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

        try copy(resource: "css/bootstrap.min.css")
        try copy(resource: "js/bootstrap.bundle.min.js")

        if site.builtInIconsEnabled {
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

    /// Renders static pages and content pages, including the homepage.
    func generateContent() throws {
        try render(site.homePage, isHomePage: true)

        for page in site.pages {
            try render(page)
        }

        for content in allContent {
            try render(content)
        }
    }

    /// Renders one page using the correct theme, which is taken either from the
    /// provided them or from the main site theme.
    func render(_ page: Page, using theme: any Theme) -> String {
        var theme = theme

        if theme is MissingTheme {
            theme = site.theme
        }

        return theme.render(page: page, context: self).render(context: self)
    }

    /// Generates all tags pages, including the "all tags" page.
    func generateTagPages() throws {
        if site.tagPage is EmptyTagPage { return }

        /// Creates a unique list of sorted tags from across the site, starting
        /// with `nil` for the "all tags" page.
        let tags: [String?] = [nil] + Set(allContent.flatMap(\.tags)).sorted()

        for tag in tags {
            let path: String

            if let tag {
                path = "tags/\(tag.convertedToSlug() ?? tag)"
            } else {
                path = "tags"
            }

            let outputDirectory = buildDirectory.appending(path: path)

            let body = Group(items: site.tagPage.body(tag: tag, context: self), context: self)

            let page = Page(
                title: "Tags",
                description: "Tags",
                url: site.url.appending(path: path),
                body: body
            )

            let outputString = render(page, using: site.tagPage.theme)

            try write(outputString, to: outputDirectory, priority: tag == nil ? 0.7 : 0.6)
        }
    }

    /// Renders a static page.
    /// - Parameters:
    ///   - page: The page to render.
    ///   - isHomePage: True if this is your site's homepage; this affects the
    ///   final path that is written to.
    func render(_ staticPage: any StaticPage, isHomePage: Bool = false) throws {
        let body = Group(items: staticPage.body(context: self), context: self)

        let path = isHomePage ? "" : staticPage.path

        let page = Page(
            title: staticPage.title,
            description: staticPage.description,
            url: site.url.appending(path: path),
            image: staticPage.image,
            body: body
        )

        let outputString = render(page, using: staticPage.theme)

        let outputDirectory = buildDirectory.appending(path: path)

        try write(outputString, to: outputDirectory, priority: isHomePage ? 1 : 0.9)
    }

    /// Renders one piece of Markdown content.
    /// - Parameter content: The content to render.
    func render(_ content: Content) throws {
        let layout = try layout(for: content)
        let body = Group(items: layout.body(content: content, context: self), context: self)
        
        let image: URL?
        
        if let imagePath = content.image {
            image = URL(string: imagePath)
        } else {
            image = nil
        }

        let page = Page(
            title: content.title,
            description: content.description,
            url: site.url.appending(path: content.path),
            image: image,
            body: body
        )

        let outputString = render(page, using: layout.theme)

        let outputDirectory = buildDirectory.appending(path: content.path)
        try write(outputString, to: outputDirectory, priority: 0.8)
    }

    /// Generates a sitemap.xml file for this site.
    func generateSiteMap() throws {
        let generator = SiteMapGenerator(context: self)
        let siteMap = generator.generateSiteMap()

        let outputURL = buildDirectory.appending(path: "sitemap.xml")

        do {
            try siteMap.write(to: outputURL, atomically: true, encoding: .utf8)
        } catch {
            throw PublishingError.failedToCreateBuildFile(outputURL)
        }
    }

    /// Generates an RSS feed for this site, if enabled.
    public func generateFeed() throws {
        guard site.isFeedEnabled else { return }

        let content = allContent.sorted(
            by: \.date,
            order: .reverse
        )

        let generator = FeedGenerator(site: site, content: content)
        let result = generator.generateFeed()

        do {
            let destinationURL = buildDirectory.appending(path: "feed.rss")
            try result.write(to: destinationURL, atomically: true, encoding: .utf8)
        } catch {
            throw PublishingError.failedToWriteFeed
        }
    }

    /// Generates a robots.txt file for this site.
    public func generateRobots() throws {
        let generator = RobotsGenerator(site: site)
        let result = generator.generateRobots()

        do {
            let destinationURL = buildDirectory.appending(path: "robots.txt")
            try result.write(to: destinationURL, atomically: true, encoding: .utf8)
        } catch {
            throw PublishingError.failedToWriteFeed
        }
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

    /// Locates the best layout to use for a piece of Markdown content. Layouts
    /// are specified using YAML front matter, but if none are found then the first
    /// layout in your site's `layouts` property is used.
    /// - Parameter content: The content that is being rendered.
    /// - Returns: The correct `ContentPage` instance to use for this content.
    func layout(for content: Content) throws -> any ContentPage {
        if let contentLayout = content.layout {
            for layout in site.layouts {
                let layoutName = String(describing: type(of: layout))

                if layoutName == contentLayout {
                    return layout
                }
            }

            throw PublishingError.missingNamedLayout(contentLayout)
        } else if let defaultLayout = site.layouts.first {
            return defaultLayout
        } else {
            throw PublishingError.missingDefaultLayout
        }
    }
}
