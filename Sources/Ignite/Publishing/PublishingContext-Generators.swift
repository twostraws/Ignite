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
        """
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
    }

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
    func generateTagLayouts() async throws {
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
                return Group(tagLayoutBody)
            }

            let page = Page(
                title: "Tags",
                description: "Tags",
                url: site.url.appending(path: path),
                body: body
            )

            let outputString = render(page, using: site.tagLayout.parentLayout)

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

    /// Generates the CSS file containing all media query rules.
    func generateMediaQueryCSS() throws {
        CSSManager.default.setThemes(site.allThemes)
        let cssPath = buildDirectory.appending(path: "css/media-queries.min.css")
        try CSSManager.default.allRules.write(to: cssPath, atomically: true, encoding: .utf8)
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
            guard let familyName = font.name else { return [] }

            // Skip if it's a system font
            guard !Font.systemFonts.contains(familyName) &&
                  !Font.monospaceFonts.contains(familyName)
            else {
                return []
            }

            return font.sources.map { source in
                guard let url = source.url else { return "" }

                if url.isFileURL {
                    return """
                    @font-face {
                        font-family: '\(familyName)';
                        src: url('/fonts/\(url.lastPathComponent)');
                        font-weight: \(source.weight.rawValue);
                        font-style: \(source.variant.rawValue);
                        font-display: swap;
                    }
                    """
                }

                if url.host()?.contains("fonts.googleapis.com") == true {
                    return """
                    @import url('\(url.absoluteString)');
                    """
                }

                return """
                @font-face {
                    font-family: '\(familyName)';
                    src: url('\(url.absoluteString)');
                    font-weight: \(source.weight.rawValue);
                    font-style: \(source.variant.rawValue);
                    font-display: swap;
                }
                """
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

        // Set initial root variables
        cssContent += """
        :root {
            --supports-light-theme: \(supportsLightTheme);
            --supports-dark-theme: \(supportsDarkTheme);
        }

        html {
            font-size: var(--bs-root-font-size, 16px);
        }

        body {
            font-family: var(--bs-body-font-family);
            font-size: var(--bs-body-font-size, 1rem);
        }

        """

        // Container defaults
        cssContent += containerDefaults

        // Generate theme variables
        if let lightTheme = site.lightTheme {
            // Only output light theme variables if it's the only theme
            if !supportsDarkTheme {
                cssContent += """
                :root {
                    \(generateThemeVariables(lightTheme))
                }

                [data-bs-theme="\(lightTheme.id)"] {
                    \(generateThemeVariables(lightTheme))
                }
                """
            } else {
                // If both themes exist, use the standard structure
                cssContent += """
                :root {
                    \(generateThemeVariables(lightTheme))
                }

                [data-bs-theme="light"] {
                    \(generateThemeVariables(lightTheme))
                }

                [data-bs-theme="auto"] {
                    \(generateThemeVariables(lightTheme))
                }
                """
            }
        }

        // Generate dark theme overrides
        if let darkTheme = site.darkTheme {
            // Only output dark theme variables if it's the only theme
            if !supportsLightTheme {
                cssContent += """
                :root {
                    \(generateThemeVariables(darkTheme))
                }

                [data-bs-theme="\(darkTheme.id)"] {
                    \(generateThemeVariables(darkTheme))
                }
                """
            } else {
                // If both themes exist, use the standard structure with media query
                cssContent += """
                @media (prefers-color-scheme: dark) {
                    :root {
                        \(generateThemeVariables(darkTheme))
                    }

                    [data-bs-theme="dark"] {
                        \(generateThemeVariables(darkTheme))
                    }

                    [data-bs-theme="auto"] {
                        \(generateThemeVariables(darkTheme))
                    }
                }
                """
            }
        }

        let cssPath = buildDirectory.appending(path: "css/themes.min.css")
        try cssContent.write(to: cssPath, atomically: true, encoding: .utf8)
    }

    /// Generates CSS rules for the given theme using the specified selector, including color variables and basic styling.
    private func generateThemeRules(_ theme: Theme, selector: String) -> String {
        var rules = ["\(selector) {", generateThemeVariables(theme), "}"]

        var bodyStyles: [String] = []
        if !theme.primary.isDefault { bodyStyles.append("color: var(--bs-body-color)") }
        if !theme.background.isDefault { bodyStyles.append("background-color: var(--bs-body-bg)") }
        if !theme.font.isDefault { bodyStyles.append("font-family: var(--bs-body-font-family)") }
        if !theme.bodySize.isDefault { bodyStyles.append("font-size: var(--bs-body-font-size)") }
        if !theme.regularLineHeight.isDefault { bodyStyles.append("line-height: var(--bs-body-line-height)") }

        if !bodyStyles.isEmpty {
            rules.append("\(selector) {")
            rules.append(bodyStyles.joined(separator: ";\n"))
            rules.append("}")
        }

        if !theme.link.isDefault {
            rules.append("\(selector) a { color: var(--bs-link-color); }")
        }
        if !theme.linkHover.isDefault {
            rules.append("\(selector) a:hover { color: var(--bs-link-hover-color); }")
        }

        var headingStyles: [String] = []
        if !theme.headingBottomMargin.isDefault { headingStyles.append("margin-bottom: var(--bs-headings-margin-bottom)") }
        if !theme.headingFontWeight.isDefault { headingStyles.append("font-weight: var(--bs-headings-font-weight)") }
        if !theme.headingLineHeight.isDefault { headingStyles.append("line-height: var(--bs-headings-line-height)") }

        if !headingStyles.isEmpty {
            rules.append("""
            \(selector) h1, \(selector) h2, \(selector) h3,
            \(selector) h4, \(selector) h5, \(selector) h6 {
                \(headingStyles.joined(separator: ";\n"))
            }
            """)
        }

        if !theme.xxLargeHeadingSize.isDefault { rules.append("\(selector) h1 { font-size: var(--bs-h1-font-size); }") }
        if !theme.xLargeHeadingSize.isDefault { rules.append("\(selector) h2 { font-size: var(--bs-h2-font-size); }") }
        if !theme.largeHeadingSize.isDefault { rules.append("\(selector) h3 { font-size: var(--bs-h3-font-size); }") }
        if !theme.mediumHeadingSize.isDefault { rules.append("\(selector) h4 { font-size: var(--bs-h4-font-size); }") }
        if !theme.smallHeadingSize.isDefault { rules.append("\(selector) h5 { font-size: var(--bs-h5-font-size); }") }
        if !theme.xSmallHeadingSize.isDefault { rules.append("\(selector) h6 { font-size: var(--bs-h6-font-size); }") }

        if !theme.monospaceFont.isDefault {
            rules.append("\(selector) code, \(selector) pre { font-family: var(--bs-font-monospace); }")
        }

        return rules.joined(separator: "\n\n")
    }

    // swiftlint:disable function_body_length
    private func generateThemeVariables(_ theme: Theme) -> String {
        var cssProperties: [String] = []

        // Helper function to add property if it exists
        func addProperty(_ variable: BootstrapVariable, _ value: any Defaultable) {
            if value.isDefault == false {
                cssProperties.append("\(variable.rawValue): \(value)")
            }
        }

        // Helper function specifically for font properties
        func addFont(_ variable: BootstrapVariable, _ font: Font, defaultFonts: [String]) {
            if !font.isDefault {
                cssProperties.append("\(variable.rawValue): \(font.name ?? defaultFonts.joined(separator: ","))")
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
        addFont(.sansSerifFont, theme.sansSerifFont, defaultFonts: Font.systemFonts)
        addFont(.monospaceFont, theme.monospaceFont, defaultFonts: Font.monospaceFonts)
        addFont(.bodyFont, theme.font, defaultFonts: Font.systemFonts)
        addFont(.codeFont, theme.codeFont, defaultFonts: Font.monospaceFonts)

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

        let syntaxTheme = theme.syntaxHighlighterTheme
        if syntaxTheme != .none {
            cssProperties.append("--syntax-highlight-theme: \(syntaxTheme.description)")
        }

        return cssProperties.joined(separator: ";\n")
    }
    // swiftlint:enable function_body_length
}
