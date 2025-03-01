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

        let resolved = resolveSiteWidths(for: theme)

        return """
        .container {
            @media (min-width: \(resolved.xSmall.stringValue)) {
                max-width: var(\(BootstrapVariable.xSmallContainer.rawValue), 540px);
            }
            @media (min-width: \(resolved.small.stringValue)) {
                max-width: var(\(BootstrapVariable.smallContainer.rawValue), 540px);
            }
            @media (min-width: \(resolved.medium.stringValue)) {
                max-width: var(\(BootstrapVariable.mediumContainer.rawValue), 720px);
            }
            @media (min-width: \(resolved.large.stringValue)) {
                max-width: var(\(BootstrapVariable.largeContainer.rawValue), 960px);
            }
            @media (min-width: \(resolved.xLarge.stringValue)) {
                max-width: var(\(BootstrapVariable.xLargeContainer.rawValue), 1140px);
            }
            @media (min-width: \(resolved.xxLarge.stringValue)) {
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

        await renderTagLayouts()
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
        guard CSSManager.shared.hasCSS else { return }
        let mediaQueryCSS = CSSManager.shared.generateAllRules(themes: site.allThemes)
        let cssPath = buildDirectory.appending(path: "css/media-queries.min.css")
        do {
            try mediaQueryCSS.write(to: cssPath, atomically: true, encoding: .utf8)
        } catch {
            fatalError(.failedToWriteFile("media-queries.min.css"))
        }
    }

    /// Generates animations for the site.
    func generateAnimations() {
        let animationsPath = buildDirectory.appending(path: "css/ignite-core.min.css")
        AnimationManager.shared.write(to: animationsPath)
    }
}
