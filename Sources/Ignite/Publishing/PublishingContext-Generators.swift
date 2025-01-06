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
            fatalError("Ignite requires that you provide a light or dark theme.")
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
                return Container(tagLayoutBody)
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

    /// Generates the CSS file containing all media query rules, including styles.
    func generateMediaQueryCSS() throws {
        print("Generating CSS for custom styles. This may take a moment...")
        let mediaQueryCSS = CSSManager.default.generateAllRules(themes: site.allThemes)
        let stylesCSS = StyleManager.default.generateAllCSS(themes: site.allThemes)
        let combinedCSS = [mediaQueryCSS, stylesCSS]
            .filter { !$0.isEmpty }
            .joined(separator: "\n\n")

        let cssPath = buildDirectory.appending(path: "css/media-queries.min.css")
        try combinedCSS.write(to: cssPath, atomically: true, encoding: .utf8)
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
            theme.codeFont,
            theme.headingFont
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
    private func generateGlobalRules() -> String {
        """
        /* Global style rules */

        /* Root and body styles */
        html {
            font-size: var(--bs-root-font-size, 16px);
        }

        body {
            font-family: var(--bs-body-font-family, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", "Noto Sans", "Liberation Sans", Arial, sans-serif);
            font-size: var(--bs-body-font-size, 1rem);
            line-height: var(--bs-body-line-height, 1.5);
            color: var(--bs-body-color);
            background-color: var(--bs-body-bg);
        }
        
        /* Paragraph margin */
        p {
            margin-top: 0;
            margin-bottom: var(--bs-paragraph-margin-bottom, 1rem);
        }

        /* Heading font rules */
        h1, h2, h3, h4, h5, h6 {
            font-family: var(--bs-headings-font-family, inherit);
            margin-bottom: var(--bs-headings-margin-bottom, 0.5rem);
            font-weight: var(--bs-headings-font-weight, 500);
            line-height: var(--bs-headings-line-height, 1.2);
        }

        /* Color rules */
        .text-primary { color: var(--bs-primary) !important; }
        .text-secondary { color: var(--bs-secondary) !important; }
        .text-success { color: var(--bs-success) !important; }
        .text-info { color: var(--bs-info) !important; }
        .text-warning { color: var(--bs-warning) !important; }
        .text-danger { color: var(--bs-danger) !important; }
        .text-light { color: var(--bs-light) !important; }
        .text-dark { color: var(--bs-dark) !important; }

        /* Background rules */
        .bg-primary { background-color: var(--bs-primary) !important; }
        .bg-secondary { background-color: var(--bs-secondary) !important; }
        .bg-success { background-color: var(--bs-success) !important; }
        .bg-info { background-color: var(--bs-info) !important; }
        .bg-warning { background-color: var(--bs-warning) !important; }
        .bg-danger { background-color: var(--bs-danger) !important; }
        .bg-light { background-color: var(--bs-light) !important; }
        .bg-dark { background-color: var(--bs-dark) !important; }

        /* Button rules */
        .btn-primary { 
            background-color: var(--bs-primary);
            border-color: var(--bs-primary);
        }
        .btn-secondary {
            background-color: var(--bs-secondary);
            border-color: var(--bs-secondary);
        }
        .btn-success {
            background-color: var(--bs-success);
            border-color: var(--bs-success);
        }
        .btn-info {
            background-color: var(--bs-info);
            border-color: var(--bs-info);
        }
        .btn-warning {
            background-color: var(--bs-warning);
            border-color: var(--bs-warning);
        }
        .btn-danger {
            background-color: var(--bs-danger);
            border-color: var(--bs-danger);
        }
        .btn-light {
            background-color: var(--bs-light);
            border-color: var(--bs-light);
        }
        .btn-dark {
            background-color: var(--bs-dark);
            border-color: var(--bs-dark);
        }
        """
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

        // Root variables and default theme (light)
        if let lightTheme = site.lightTheme {
            cssContent += """
            :root {
                --supports-light-theme: \(supportsLightTheme);
                --supports-dark-theme: \(supportsDarkTheme);
                --light-theme-id: "\(site.lightTheme?.id ?? "")";
                --dark-theme-id: "\(site.darkTheme?.id ?? "")";

                /* Light theme variables (default theme) */
                \(generateThemeVariables(lightTheme))
            }

            \(containerDefaults)

            \(generateGlobalRules())

            /* Light theme override */
            [data-bs-theme="\(lightTheme.id)"] {
                \(generateThemeVariables(lightTheme))
            }

            /* Auto theme starts with light theme */
            [data-bs-theme="auto"] {
                \(generateThemeVariables(lightTheme))
            }
            """
        }

        // Dark theme handling
        if let darkTheme = site.darkTheme {
            if !supportsLightTheme {
                // Only dark theme exists - use as root
                cssContent += """
                :root {
                    --supports-light-theme: \(supportsLightTheme);
                    --supports-dark-theme: \(supportsDarkTheme);
                    --light-theme-id: "\(site.lightTheme?.id ?? "")";
                    --dark-theme-id: "\(site.darkTheme?.id ?? "")";

                    /* Dark theme variables */
                    \(generateThemeVariables(darkTheme))
                }

                \(containerDefaults)

                \(generateGlobalRules())

                [data-bs-theme="\(darkTheme.id)"] {
                    \(generateThemeVariables(darkTheme))
                }
                """
            } else {
                // Both themes exist - update auto theme in dark mode and add explicit dark theme
                cssContent += """

                /* Dark theme media query for auto theme */
                @media (prefers-color-scheme: dark) {
                    [data-bs-theme="auto"] {
                        \(generateThemeVariables(darkTheme))
                    }
                }

                /* Explicit dark theme */
                [data-bs-theme="\(darkTheme.id)"] {
                    \(generateThemeVariables(darkTheme))
                }
                """
            }
        }

        for theme in site.alternateThemes {
            cssContent += """

            /* Alternate theme: \(theme.name) */
            [data-bs-theme="\(theme.id)"] {
                \(generateThemeVariables(theme))
            }
            """
        }

        let cssPath = buildDirectory.appending(path: "css/themes.min.css")
        try cssContent.write(to: cssPath, atomically: true, encoding: .utf8)
    }

    // swiftlint:disable function_body_length
    /// Generates CSS variables for a theme's colors, typography, spacing, and other customizable properties.
    private func generateThemeVariables(_ theme: Theme) -> String {
        var cssProperties: [String] = []

        // Helper function to add property if it exists
        func addProperty(_ variable: BootstrapVariable, _ value: any Defaultable) {
            if value.isDefault == false {
                cssProperties.append("    \(variable.rawValue): \(value)")
            }
        }

        // Helper function specifically for font properties
        func addFont(_ variable: BootstrapVariable, _ font: Font, defaultFonts: [String]) {
            if !font.isDefault {
                cssProperties.append("    \(variable.rawValue): \(font.name ?? defaultFonts.joined(separator: ","))")
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
        addFont(.headingFont, theme.headingFont, defaultFonts: Font.systemFonts)

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
        addProperty(.smallContainer, theme.smallMaxWidth)
        addProperty(.mediumContainer, theme.mediumMaxWidth)
        addProperty(.largeContainer, theme.largeMaxWidth)
        addProperty(.xLargeContainer, theme.xLargeMaxWidth)
        addProperty(.xxLargeContainer, theme.xxLargeMaxWidth)

        // Breakpoints
        addProperty(.smallBreakpoint, theme.smallBreakpoint)
        addProperty(.mediumBreakpoint, theme.mediumBreakpoint)
        addProperty(.largeBreakpoint, theme.largeBreakpoint)
        addProperty(.xLargeBreakpoint, theme.xLargeBreakpoint)
        addProperty(.xxLargeBreakpoint, theme.xxLargeBreakpoint)

        let syntaxTheme = theme.syntaxHighlighterTheme
        if syntaxTheme != .none {
            cssProperties.append("    --syntax-highlight-theme: \(syntaxTheme.description)")
        }

        return cssProperties.joined(separator: ";\n")
    }
    // swiftlint:enable function_body_length
}
