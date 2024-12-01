//
// PublishingContext-Generators.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Renders static pages and content pages, including the homepage.
    func generateContent() async throws {
        try render(site.homePage, isHomePage: true)

        for page in site.pages {
            try render(page)
        }

        for content in allContent {
            try render(content)
        }
        currentRenderingPath = nil
    }

    /// Generates all tags pages, including the "all tags" page.
    func generateTagPages() async throws {
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

            let body = render(page: nil) {
                TagContext.withCurrentTag(tag, content: content(tagged: tag)) {
                    let tagPageBody = site.tagPage.body
                    return Group(tagPageBody)
                }
            }

            let page = Page(
                title: "Tags",
                description: "Tags",
                url: site.url.appending(path: path),
                body: body
            )

            let outputString = render(page: page) {
                render(page, using: site.tagPage.theme)
            }

            try write(outputString, to: outputDirectory, priority: tag == nil ? 0.7 : 0.6)
        }
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
            let destinationURL = buildDirectory.appending(path: site.feedConfiguration.path)
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

    /// Generates animations for the site.
    func generateAnimations() {
        guard AnimationManager.default.hasAnimations else { return }
        let animationsPath = buildDirectory.appending(path: "css/animations.min.css")
        AnimationManager.default.write(to: animationsPath)
    }
}
