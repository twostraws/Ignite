//
// PublishingContext-Generators.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Contains the various snap dimensions for different Bootstrap widths.
    var containerDefaults: String {
        guard let theme = site.lightTheme ?? site.darkTheme else {
            fatalError(.missingDefaultTheme)
        }

        return """
        .container {
            @media (min-width: \(theme.smallBreakpoint.stringValue)) {
                max-width: var(\(BootstrapVariable.smallContainer.rawValue), 540px);
            }
            @media (min-width: \(theme.mediumBreakpoint.stringValue)) {
                max-width: var(\(BootstrapVariable.mediumContainer.rawValue), 720px);
            }
            @media (min-width: \(theme.largeBreakpoint.stringValue)) {
                max-width: var(\(BootstrapVariable.largeContainer.rawValue), 960px);
            }
            @media (min-width: \(theme.xLargeBreakpoint.stringValue)) {
                max-width: var(\(BootstrapVariable.xLargeContainer.rawValue), 1140px);
            }
            @media (min-width: \(theme.xxLargeBreakpoint.stringValue)) {
                max-width: var(\(BootstrapVariable.xxLargeContainer.rawValue), 1320px);
            }
        }
        """
    }

    /// Renders static pages and content pages, including the homepage.
    func generateContent() async {
        render(site.homePage, isHomePage: true)

        for page in site.staticLayouts {
            render(page)
        }

        for content in allContent {
            render(content)
        }
        currentRenderingPath = nil
    }

    /// Generates all tags pages, including the "all tags" page.
    func generateTagLayouts() async {
        if site.tagLayout is EmptyTagLayout { return }

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

            let body = TagContext.withCurrentTag(tag, content: content(tagged: tag)) {
                let tagLayoutBody = site.tagLayout.body
                return Section(tagLayoutBody)
            }

            let page = Page(
                title: "Tags",
                description: "Tags",
                url: site.url.appending(path: path),
                body: body
            )

            let outputString = render(page, using: site.tagLayout.parentLayout)

            write(outputString, to: outputDirectory, priority: tag == nil ? 0.7 : 0.6)
        }
    }

    /// Generates a sitemap.xml file for this site.
    func generateSiteMap() {
        let generator = SiteMapGenerator(context: self)
        let siteMap = generator.generateSiteMap()

        let outputURL = buildDirectory.appending(path: "sitemap.xml")

        do {
            try siteMap.write(to: outputURL, atomically: true, encoding: .utf8)
        } catch {
            fatalError(.failedToCreateBuildFile(outputURL))
        }
    }

    /// Generates an RSS feed for this site, if enabled.
    public func generateFeed() {
        guard let feedConfig = site.feedConfiguration else { return }

        let content = allContent.sorted(
            by: \.date,
            order: .reverse
        )

        let generator = FeedGenerator(config: feedConfig, site: site, content: content)
        let result = generator.generateFeed()

        do {
            let destinationURL = buildDirectory.appending(path: feedConfig.path)
            try result.write(to: destinationURL, atomically: true, encoding: .utf8)
        } catch {
            addError(.failedToWriteFeed)
        }
    }

    /// Generates a robots.txt file for this site.
    public func generateRobots() {
        let generator = RobotsGenerator(site: site)
        let result = generator.generateRobots()

        do {
            let destinationURL = buildDirectory.appending(path: "robots.txt")
            try result.write(to: destinationURL, atomically: true, encoding: .utf8)
        } catch {
            addError(.failedToWriteFile("robots.txt"))
        }
    }

    /// Generates the CSS file containing all media query rules.
    func generateMediaQueryCSS() {
        guard CSSManager.default.hasCSS else { return }
        CSSManager.default.setThemes(site.allThemes)
        let cssPath = buildDirectory.appending(path: "css/media-queries.min.css")
        do {
            try CSSManager.default.allRules.write(to: cssPath, atomically: true, encoding: .utf8)
        } catch {
            fatalError(.failedToWriteFile("media-queries.min.css"))
        }
    }

    /// Generates animations for the site.
    func generateAnimations() {
        guard AnimationManager.default.hasAnimations else { return }
        let animationsPath = buildDirectory.appending(path: "css/animations.min.css")
        AnimationManager.default.write(to: animationsPath)
    }
}
