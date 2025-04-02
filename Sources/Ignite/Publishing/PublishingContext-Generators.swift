//
// PublishingContext-Generators.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Renders static pages and content pages, including the homepage.
    func generateContent() async {
        render(homePage: site.homePage)

        for page in site.staticPages {
            render(page)
        }

        for content in allContent {
            render(content)
        }

        currentRenderingPath = nil

        await renderTagPages()
        await renderErrorPages()
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

    /// Generates the CSS file containing all media query rules, including styles.
    func generateMediaQueryCSS() {
        print("Generating CSS for custom styles. This may take a moment...")
        let mediaQueryCSS = CSSManager.shared.generateAllRules(themes: site.allThemes)
        let stylesCSS = StyleManager.shared.generateAllCSS(themes: site.allThemes)
        let combinedCSS = [mediaQueryCSS, stylesCSS]
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")

        do {
            let igniteCoreDirectory = buildDirectory.appending(path: "css/ignite-core.min.css")
            let existingContent = try String(contentsOf: igniteCoreDirectory, encoding: .utf8)
            let newContent = existingContent + "\n\n" + combinedCSS
            try newContent.write(to: igniteCoreDirectory, atomically: true, encoding: .utf8)
        } catch {
            addError(.failedToWriteFile("css/ignite-core.min.css"))
        }
    }

    /// Generates animations for the site.
    func generateAnimations() {
        let animationsPath = buildDirectory.appending(path: "css/ignite-core.min.css")
        AnimationManager.shared.write(to: animationsPath)
    }
}
