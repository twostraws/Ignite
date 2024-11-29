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

        for page in site.staticLayouts {
            try render(page)
        }

        for content in allContent {
            try render(content)
        }
        currentRenderingPath = nil
    }

    /// Generates all tags pages, including the "all tags" page.
    func generateTagPages() async throws {
        if site.tagPage is EmptyTagLayout { return }

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
                let tagPageBody = site.tagPage.body
                return Group(tagPageBody)
            }

            let page = Page(
                title: "Tags",
                description: "Tags",
                url: site.url.appending(path: path),
                body: body
            )

            let outputString = render(page)

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
            guard let font,
                  let name = font.name,
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

        let supportsLightTheme = site.lightTheme != nil
        let supportsDarkTheme = site.darkTheme != nil

        guard supportsLightTheme || supportsDarkTheme else {
            fatalError("Ignite requires that you provide a light or dark theme.")
        }

        cssContent += """
        :root {
            --supports-light-theme: \(supportsLightTheme);
            --supports-dark-theme: \(supportsDarkTheme);
            --bs-root-font-size: 16px;
            font-size: var(--bs-root-font-size);
        }

        """

        // Container defaults
        cssContent += """
        .container {
            @media (min-width: 576px) {
                max-width: var(\(BootstrapVariable.containerSm.rawValue), 540px);
            }
            @media (min-width: 768px) {
                max-width: var(\(BootstrapVariable.containerMd.rawValue), 720px);
            }
            @media (min-width: 992px) {
                max-width: var(\(BootstrapVariable.containerLg.rawValue), 960px);
            }
            @media (min-width: 1200px) {
                max-width: var(\(BootstrapVariable.containerXl.rawValue), 1140px);
            }
            @media (min-width: 1400px) {
                max-width: var(\(BootstrapVariable.containerXxl.rawValue), 1320px);
            }
        }

        """

        // Generate alternate theme overrides
        for theme in themes {
            cssContent += """
            [data-bs-theme="\(theme.id.kebabCased())"] {
                \(generateThemeVariables(theme))
            }
            
            """
        }

        let cssPath = buildDirectory.appending(path: "css/themes.min.css")
        try cssContent.write(to: cssPath, atomically: true, encoding: .utf8)
    }

    private func generateThemeVariables(_ theme: Theme) -> String {
        var cssProperties: [String] = []

        // Helper function to add property if it exists
        func addProperty(_ variable: BootstrapVariable, _ value: Any?) {
            if let value = value {
                cssProperties.append("\(variable.rawValue): \(value)")
            }
        }

        // Brand colors
        addProperty(.primary, theme.accent)
        addProperty(.secondary, theme.secondaryAccent)
        addProperty(.success, theme.success)
        addProperty(.info, theme.info)
        addProperty(.warning, theme.warning)
        addProperty(.danger, theme.danger)
        addProperty(.light, theme.light)
        addProperty(.dark, theme.dark)

        // Body settings
        addProperty(.bodyColor, theme.primary)
        addProperty(.bodyBackground, theme.background)

        // Emphasis colors
        addProperty(.emphasisColor, theme.emphasis)
        addProperty(.secondaryColor, theme.secondary)
        addProperty(.tertiaryColor, theme.tertiary)

        // Background colors
        addProperty(.secondaryBackground, theme.secondaryBackground)
        addProperty(.tertiaryBackground, theme.tertiaryBackground)

        // Link colors
        addProperty(.linkColor, theme.link)
        addProperty(.linkHoverColor, theme.linkHover)

        // Border colors
        addProperty(.borderColor, theme.border)

        // Font families
        addProperty(.sansSerifFont, theme.sansSerifFont?.name ?? Font.systemFonts)
        addProperty(.monospaceFont, theme.monospaceFont?.name ?? Font.monospaceFonts)
        addProperty(.bodyFont, theme.font?.name ?? Font.systemFonts)
        addProperty(.codeFont, theme.codeFont?.name ?? Font.monospaceFonts)

        // Font sizes
        addProperty(.rootFontSize, theme.rootFontSize)
        addProperty(.bodyFontSize, theme.bodySize)
        addProperty(.smallBodyFontSize, theme.smallBodySize)
        addProperty(.largeBodyFontSize, theme.largeBodySize)

        // Heading sizes
        addProperty(.h1FontSize, theme.xxLargeHeadingSize)
        addProperty(.h2FontSize, theme.xLargeHeadingSize)
        addProperty(.h3FontSize, theme.largeHeadingSize)
        addProperty(.h4FontSize, theme.mediumHeadingSize)
        addProperty(.h5FontSize, theme.smallHeadingSize)
        addProperty(.h6FontSize, theme.xSmallHeadingSize)

        // Font weights
        addProperty(.lighterFontWeight, theme.lighterFontWeight)
        addProperty(.lightFontWeight, theme.lightFontWeight)
        addProperty(.normalFontWeight, theme.regularFontWeight)
        addProperty(.boldFontWeight, theme.boldFontWeight)
        addProperty(.bolderFontWeight, theme.bolderFontWeight)

        // Line heights
        addProperty(.bodyLineHeight, theme.regularLineHeight)
        addProperty(.condensedLineHeight, theme.condensedLineHeight)
        addProperty(.expandedLineHeight, theme.expandedLineHeight)

        // Heading properties
        addProperty(.headingsMarginBottom, theme.headingBottomMargin)
        addProperty(.headingsFontWeight, theme.headingFontWeight)
        addProperty(.headingsLineHeight, theme.headingLineHeight)

        // Container sizes
        addProperty(.containerSm, theme.smallMaxWidth)
        addProperty(.containerMd, theme.mediumMaxWidth)
        addProperty(.containerLg, theme.largeMaxWidth)
        addProperty(.containerXl, theme.xLargeMaxWidth)
        addProperty(.containerXxl, theme.xxLargeMaxWidth)

        return cssProperties.joined(separator: ";\n")
    }
}
