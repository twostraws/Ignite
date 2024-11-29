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

    /// Generates @font-face CSS declarations for custom fonts in a theme, excluding system fonts.
    private func generateFontFaces(_ theme: Theme) -> String {
        let fonts = [
            theme.sansSerifFont,
            theme.monospaceFont,
            theme.font,
            theme.codeFont
        ] + theme.alternateFonts

        let fontTags = fonts.flatMap { font -> [String] in
            guard let name = font.name,
                  !font.sources.isEmpty,
                  !name.contains(Font.systemFonts),
                  !name.contains(Font.monospaceFonts)
            else {
                return []
            }

            return font.sources.map { source in
                if let url = source.url {
                    if url.host()?.contains("fonts.googleapis.com") == true {
                        // For Google Fonts, use @import
                        return """
                        @import url('\(url.absoluteString)');
                        """
                    } else {
                        // For other remote fonts
                        return """
                        @font-face {
                            font-family: '\(name)';
                            src: url('\(url.absoluteString)');
                            font-weight: \(source.weight.rawValue);
                            font-style: \(source.style.rawValue);
                            font-display: swap;
                        }
                        """
                    }
                } else {
                    // For local fonts
                    return """
                    @font-face {
                        font-family: '\(name)';
                        src: url('/fonts/\(source.name)');
                        font-weight: \(source.weight.rawValue);
                        font-style: \(source.style.rawValue);
                        font-display: swap;
                    }
                    """
                }
            }
        }.joined(separator: "\n\n")

        return fontTags
    }

    /// Generates CSS for all themes including font faces, colors, and typography settings, writing to themes.min.css.
    func generateThemes(_ themes: [any Theme]) throws {
        guard !themes.isEmpty else { return }
        var cssContent = ""

        // Generate font faces first
        for theme in themes {
            let fontFaces = generateFontFaces(theme)
            if !fontFaces.isEmpty {
                cssContent += fontFaces + "\n\n"
            }
        }

        cssContent += """
        .container {
            @media (min-width: 576px) {
                max-width: var(--theme-container-sm, 540px);  /* Added fallback */
            }
            @media (min-width: 768px) {
                max-width: var(--theme-container-md, 720px);  /* Added fallback */
            }
            @media (min-width: 992px) {
                max-width: var(--theme-container-lg, 960px);  /* Added fallback */
            }
            @media (min-width: 1200px) {
                max-width: var(--theme-container-xl, 1140px); /* Added fallback */
            }
            @media (min-width: 1400px) {
                max-width: var(--theme-container-xxl, 1320px); /* Added fallback */
            }
        }
        
        """

        // Generate alternate theme overrides
        for theme in themes {
            cssContent += """
            [data-bs-theme="\(theme.id.kebabCased())"] {
                --theme-container-sm: \(theme.smallMaxWidth);
                --theme-container-md: \(theme.mediumMaxWidth);
                --theme-container-lg: \(theme.largeMaxWidth);
                --theme-container-xl: \(theme.xLargeMaxWidth);
                --theme-container-xxl: \(theme.xxLargeMaxWidth);
                \(generateThemeVariables(theme))
            }
            
            """
        }

        let cssPath = buildDirectory.appending(path: "css/themes.min.css")
        try cssContent.write(to: cssPath, atomically: true, encoding: .utf8)
    }

    private func generateThemeVariables(_ theme: Theme) -> String {
        """
        /* Bootstrap theme colors */
        --bs-primary: \(theme.accent);
        --bs-secondary: \(theme.secondaryAccent);
        --bs-success: \(theme.success);
        --bs-info: \(theme.info);
        --bs-warning: \(theme.warning);
        --bs-danger: \(theme.danger);
        --bs-light: \(theme.light);
        --bs-dark: \(theme.dark);

        /* Body settings */
        --bs-body-color: \(theme.primary);
        --bs-body-bg: \(theme.primaryBackground);

        /* Emphasis colors */
        --bs-emphasis-color: \(theme.emphasis);
        --bs-secondary-color: \(theme.secondary);
        --bs-tertiary-color: \(theme.tertiary);

        /* Background colors */
        --bs-secondary-bg: \(theme.secondaryBackground);
        --bs-tertiary-bg: \(theme.tertiaryBackground);

        /* Link colors */
        --bs-link-color: \(theme.link);
        --bs-link-hover-color: \(theme.linkHover);

        /* Border colors */
        --bs-border-color: \(theme.border);
        
        /* Font families */
        --bs-font-sans-serif: \(theme.sansSerifFont.name ?? Font.systemFonts);
        --bs-font-monospace: \(theme.monospaceFont.name ?? Font.monospaceFonts);
        --bs-body-font-family: \(theme.font.name ?? Font.systemFonts);
        --bs-font-code: \(theme.codeFont.name ?? Font.monospaceFonts);

        /* Font sizes */
        --bs-root-font-size: \(theme.rootFontSize ?? "null");
        --bs-body-font-size: \(theme.bodySize);
        --bs-body-font-size-sm: \(theme.smallBodySize);
        --bs-body-font-size-lg: \(theme.largeBodySize);

        /* Font weights */
        --bs-font-weight-lighter: \(theme.lighterFontWeight);
        --bs-font-weight-light: \(theme.lightFontWeight);
        --bs-font-weight-normal: \(theme.regularFontWeight);
        --bs-font-weight-bold: \(theme.boldFontWeight);
        --bs-font-weight-bolder: \(theme.bolderFontWeight);

        /* Line heights */
        --bs-body-line-height: \(theme.regularLineHeight);
        --bs-line-height-sm: \(theme.condensedLineHeight);
        --bs-line-height-lg: \(theme.expandedLineHeight);

        /* Heading properties */
        --bs-headings-margin-bottom: \(theme.headingBottomMargin);
        --bs-headings-font-weight: \(theme.headingFontWeight);
        --bs-headings-line-height: \(theme.headingLineHeight);
        """
    }
}
