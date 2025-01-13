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
                return Section(tagLayoutBody)
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
            theme.codeFont,
            theme.headingFont
        ] + theme.alternateFonts

        var uniqueSources: Set<String> = []

        let fontTags = fonts.flatMap { font -> [String] in
            guard let familyName = font.name else { return [] }

            // Skip if it's a system font
            guard !Font.systemFonts.contains(familyName) &&
                  !Font.monospaceFonts.contains(familyName)
            else {
                return []
            }

            return font.sources.compactMap { source in
                guard let url = source.url else { return nil }

                // Create a unique key for this font source
                let sourceKey = "\(familyName)-\(source.weight.rawValue)-\(source.variant.rawValue)-\(url.absoluteString)"

                // Skip if we've already processed this source
                guard !uniqueSources.contains(sourceKey) else {
                    return nil
                }

                uniqueSources.insert(sourceKey)

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

    // swiftlint:disable function_body_length
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
        
        /* Link styles */
        a {
            color: var(--bs-link-color);
            text-decoration: var(--bs-link-decoration, underline);
        }

        a:hover {
            color: var(--bs-link-hover-color);
        }

        /* Link role styles */
        .link-primary {
            color: var(--bs-primary) !important;
            text-decoration-color: var(--bs-primary) !important;
        }
        .link-primary:hover {
            color: rgba(var(--bs-primary-rgb), 0.8) !important;
            text-decoration-color: rgba(var(--bs-primary-rgb), 0.8) !important;
        }

        .link-secondary {
            color: var(--bs-secondary) !important;
            text-decoration-color: var(--bs-secondary) !important;
        }
        .link-secondary:hover {
            color: rgba(var(--bs-secondary-rgb), 0.8) !important;
            text-decoration-color: rgba(var(--bs-secondary-rgb), 0.8) !important;
        }

        .link-success {
            color: var(--bs-success) !important;
            text-decoration-color: var(--bs-success) !important;
        }
        .link-success:hover {
            color: rgba(var(--bs-success-rgb), 0.8) !important;
            text-decoration-color: rgba(var(--bs-success-rgb), 0.8) !important;
        }

        .link-info {
            color: var(--bs-info) !important;
            text-decoration-color: var(--bs-info) !important;
        }
        .link-info:hover {
            color: rgba(var(--bs-info-rgb), 0.8) !important;
            text-decoration-color: rgba(var(--bs-info-rgb), 0.8) !important;
        }

        .link-warning {
            color: var(--bs-warning) !important;
            text-decoration-color: var(--bs-warning) !important;
        }
        .link-warning:hover {
            color: rgba(var(--bs-warning-rgb), 0.8) !important;
            text-decoration-color: rgba(var(--bs-warning-rgb), 0.8) !important;
        }

        .link-danger {
            color: var(--bs-danger) !important;
            text-decoration-color: var(--bs-danger) !important;
        }
        .link-danger:hover {
            color: rgba(var(--bs-danger-rgb), 0.8) !important;
            text-decoration-color: rgba(var(--bs-danger-rgb), 0.8) !important;
        }

        .link-light {
            color: var(--bs-light) !important;
            text-decoration-color: var(--bs-light) !important;
        }
        .link-light:hover {
            color: rgba(var(--bs-light-rgb), 0.8) !important;
            text-decoration-color: rgba(var(--bs-light-rgb), 0.8) !important;
        }

        .link-dark {
            color: var(--bs-dark) !important;
            text-decoration-color: var(--bs-dark) !important;
        }
        .link-dark:hover {
            color: rgba(var(--bs-dark-rgb), 0.8) !important;
            text-decoration-color: rgba(var(--bs-dark-rgb), 0.8) !important;
        }

        /* Alert styles */
        .alert-primary {
            color: var(--bs-primary-text-emphasis);
            background-color: var(--bs-primary-bg-subtle);
            border-color: var(--bs-primary-border-subtle);
        }

        .alert-secondary {
            color: var(--bs-secondary-text-emphasis);
            background-color: var(--bs-secondary-bg-subtle);
            border-color: var(--bs-secondary-border-subtle);
        }

        .alert-success {
            color: var(--bs-success-text-emphasis);
            background-color: var(--bs-success-bg-subtle);
            border-color: var(--bs-success-border-subtle);
        }

        .alert-info {
            color: var(--bs-info-text-emphasis);
            background-color: var(--bs-info-bg-subtle);
            border-color: var(--bs-info-border-subtle);
        }

        .alert-warning {
            color: var(--bs-warning-text-emphasis);
            background-color: var(--bs-warning-bg-subtle);
            border-color: var(--bs-warning-border-subtle);
        }

        .alert-danger {
            color: var(--bs-danger-text-emphasis);
            background-color: var(--bs-danger-bg-subtle);
            border-color: var(--bs-danger-border-subtle);
        }

        .alert-light {
            color: var(--bs-light-text-emphasis);
            background-color: var(--bs-light-bg-subtle);
            border-color: var(--bs-light-border-subtle);
        }

        .alert-dark {
            color: var(--bs-dark-text-emphasis);
            background-color: var(--bs-dark-bg-subtle);
            border-color: var(--bs-dark-border-subtle);
        }

        /* Subtle backgrounds */
        .bg-primary-subtle {
            background-color: rgba(var(--bs-primary-rgb), 0.15) !important;
        }

        .bg-secondary-subtle {
            background-color: rgba(var(--bs-secondary-rgb), 0.15) !important;
        }

        .bg-success-subtle {
            background-color: rgba(var(--bs-success-rgb), 0.15) !important;
        }

        .bg-info-subtle {
            background-color: rgba(var(--bs-info-rgb), 0.15) !important;
        }

        .bg-warning-subtle {
            background-color: rgba(var(--bs-warning-rgb), 0.15) !important;
        }

        .bg-danger-subtle {
            background-color: rgba(var(--bs-danger-rgb), 0.15) !important;
        }

        .bg-light-subtle {
            background-color: rgba(var(--bs-light-rgb), 0.15) !important;
        }

        .bg-dark-subtle {
            background-color: rgba(var(--bs-dark-rgb), 0.15) !important;
        }

        /* Card with solid background */
        .text-bg-primary {
            color: #fff;
            background-color: var(--bs-primary) !important;
        }

        .text-bg-secondary {
            color: #fff;
            background-color: var(--bs-secondary) !important;
        }

        .text-bg-success {
            color: #fff;
            background-color: var(--bs-success) !important;
        }

        .text-bg-info {
            color: #000;
            background-color: var(--bs-info) !important;
        }

        .text-bg-warning {
            color: #000;
            background-color: var(--bs-warning) !important;
        }

        .text-bg-danger {
            color: #fff;
            background-color: var(--bs-danger) !important;
        }

        .text-bg-light {
            color: #000;
            background-color: var(--bs-light) !important;
        }

        .text-bg-dark {
            color: #fff;
            background-color: var(--bs-dark) !important;
        }

        /* Card with colored border */
        .border-primary {
            border-color: var(--bs-primary) !important;
        }

        .border-secondary {
            border-color: var(--bs-secondary) !important;
        }

        .border-success {
            border-color: var(--bs-success) !important;
        }

        .border-info {
            border-color: var(--bs-info) !important;
        }

        .border-warning {
            border-color: var(--bs-warning) !important;
        }

        .border-danger {
            border-color: var(--bs-danger) !important;
        }

        .border-light {
            border-color: var(--bs-light) !important;
        }

        .border-dark {
            border-color: var(--bs-dark) !important;
        }
        
        /* Paragraph margin */
        p {
            margin-top: 0;
            margin-bottom: var(--bs-paragraph-margin-bottom, 1rem);
        }

        /* Heading styles */
        h1, h2, h3, h4, h5, h6 {
            font-family: var(--bs-headings-font-family, inherit);
            margin-bottom: var(--bs-headings-margin-bottom, 0.5rem);
            font-weight: var(--bs-headings-font-weight, 500);
            line-height: var(--bs-headings-line-height, 1.2);
            color: var(--bs-heading-color, inherit);
        }

        /* Individual heading sizes */
        h1 { font-size: var(--bs-h1-font-size, 2.5rem); }
        h2 { font-size: var(--bs-h2-font-size, 2rem); }
        h3 { font-size: var(--bs-h3-font-size, 1.75rem); }
        h4 { font-size: var(--bs-h4-font-size, 1.5rem); }
        h5 { font-size: var(--bs-h5-font-size, 1.25rem); }
        h6 { font-size: var(--bs-h6-font-size, 1rem); }

        /* Font weights */
        .fw-lighter { font-weight: var(--bs-font-weight-lighter, 200); }
        .fw-light { font-weight: var(--bs-font-weight-light, 300); }
        .fw-normal { font-weight: var(--bs-font-weight-normal, 400); }
        .fw-bold { font-weight: var(--bs-font-weight-bold, 700); }
        .fw-bolder { font-weight: var(--bs-font-weight-bolder, 800); }

        /* Font sizes */
        .fs-small { font-size: var(--bs-body-font-size-sm, 0.875rem); }
        .fs-base { font-size: var(--bs-body-font-size, 1rem); }
        .fs-large { font-size: var(--bs-body-font-size-lg, 1.25rem); }

        /* Line heights */
        .lh-1 { line-height: var(--bs-line-height-condensed, 1); }
        .lh-base { line-height: var(--bs-line-height-base, 1.5); }
        .lh-lg { line-height: var(--bs-line-height-expanded, 2); }

        /* Code blocks */
        code, pre {
            font-family: var(--bs-font-monospace, monospace);
        }

        /* Border styles */
        .border { border: 1px solid var(--bs-border-color) !important; }

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
        .btn-primary:hover {
            background-color: rgba(var(--bs-primary-rgb), 0.8);
            border-color: rgba(var(--bs-primary-rgb), 0.8);
        }

        .btn-secondary {
            background-color: var(--bs-secondary);
            border-color: var(--bs-secondary);
        }
        .btn-secondary:hover {
            background-color: rgba(var(--bs-secondary-rgb), 0.8);
            border-color: rgba(var(--bs-secondary-rgb), 0.8);
        }

        .btn-success {
            background-color: var(--bs-success);
            border-color: var(--bs-success);
        }
        .btn-success:hover {
            background-color: rgba(var(--bs-success-rgb), 0.8);
            border-color: rgba(var(--bs-success-rgb), 0.8);
        }

        .btn-info {
            background-color: var(--bs-info);
            border-color: var(--bs-info);
        }
        .btn-info:hover {
            background-color: rgba(var(--bs-info-rgb), 0.8);
            border-color: rgba(var(--bs-info-rgb), 0.8);
        }

        .btn-warning {
            background-color: var(--bs-warning);
            border-color: var(--bs-warning);
        }
        .btn-warning:hover {
            background-color: rgba(var(--bs-warning-rgb), 0.8);
            border-color: rgba(var(--bs-warning-rgb), 0.8);
        }

        .btn-danger {
            background-color: var(--bs-danger);
            border-color: var(--bs-danger);
        }
        .btn-danger:hover {
            background-color: rgba(var(--bs-danger-rgb), 0.8);
            border-color: rgba(var(--bs-danger-rgb), 0.8);
        }

        .btn-light {
            background-color: var(--bs-light);
            border-color: var(--bs-light);
        }
        .btn-light:hover {
            background-color: rgba(var(--bs-light-rgb), 0.8);
            border-color: rgba(var(--bs-light-rgb), 0.8);
        }

        .btn-dark {
            background-color: var(--bs-dark);
            border-color: var(--bs-dark);
        }
        .btn-dark:hover {
            background-color: rgba(var(--bs-dark-rgb), 0.8);
            border-color: rgba(var(--bs-dark-rgb), 0.8);
        }
        """
    }
    // swiftlint:enable function_body_length

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
            let hasMultipleThemes = supportsDarkTheme || !site.alternateThemes.isEmpty
            let hasAutoTheme = supportsLightTheme && supportsDarkTheme

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
            """

            if hasMultipleThemes {
                cssContent += """

                /* Light theme override */
                [data-bs-theme="\(lightTheme.id)"] {
                    \(generateThemeVariables(lightTheme))
                }
                """
            }

            if hasAutoTheme {
                cssContent += """

                /* Auto theme starts with light theme */
                [data-bs-theme="auto"] {
                    \(generateThemeVariables(lightTheme))
                }
                """
            }
        }

        // Dark theme handling
        if let darkTheme = site.darkTheme {
            if !supportsLightTheme && site.alternateThemes.isEmpty {
                // Only dark theme exists and no alternates - use as root
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
                """
            } else {
                // Add dark theme override
                cssContent += """

                /* Explicit dark theme */
                [data-bs-theme="\(darkTheme.id)"] {
                    \(generateThemeVariables(darkTheme))
                }
                """

                // Only add auto theme dark mode if both themes exist
                if supportsLightTheme {
                    cssContent += """

                    /* Dark theme media query for auto theme */
                    @media (prefers-color-scheme: dark) {
                        [data-bs-theme="auto"] {
                            \(generateThemeVariables(darkTheme))
                        }
                    }
                    """
                }
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

        // Helper function specifically for color properties
        func addColor(_ variable: BootstrapVariable, _ color: Color) {
            if !color.isDefault {
                cssProperties.append("    \(variable.rawValue): \(color)")
                cssProperties.append("    \(variable.rawValue)-rgb: \(color.red), \(color.green), \(color.blue)")

                if variable.isThemeColor {
                    // Generate subtle background, border, and text emphasis variants
                    let bgSubtleColor = theme is DarkTheme ? color.weighted(.darkest) : color.weighted(.lightest)
                    var emphasisColor = theme is DarkTheme ? color.weighted(.light) : color.weighted(.darker)
                    var borderSubtleColor = theme is DarkTheme ? color.weighted(.dark) : color.weighted(.light)

                    // Special handling for dark and light roles to ensure proper border and text visibility
                    switch variable {
                    case .dark where theme is DarkTheme:
                        borderSubtleColor = color.weighted(.semiLight)
                        emphasisColor = color.weighted(.lightest)
                    case .light where theme is DarkTheme:
                        borderSubtleColor = color.weighted(.darker)
                    case .light:
                        borderSubtleColor = color.weighted(.semiDark)
                        emphasisColor = color.weighted(.darkest)
                    default: break
                    }

                    cssProperties.append("    \(variable.rawValue)-text-emphasis: \(emphasisColor)")
                    cssProperties.append("    \(variable.rawValue)-bg-subtle: \(bgSubtleColor)")
                    cssProperties.append("    \(variable.rawValue)-border-subtle: \(borderSubtleColor)")
                }
            }
        }

        // Helper function specifically for font properties
        func addFont(_ variable: BootstrapVariable, _ font: Font, defaultFonts: [String]) {
            if !font.isDefault {
                cssProperties.append("    \(variable.rawValue): \(font.name ?? defaultFonts.joined(separator: ","))")
            }
        }

        // Brand colors
        addColor(.primary, theme.accent)
        addColor(.secondary, theme.secondaryAccent)
        addColor(.success, theme.success)
        addColor(.info, theme.info)
        addColor(.warning, theme.warning)
        addColor(.danger, theme.danger)
        addColor(.light, theme.light)
        addColor(.dark, theme.dark)

        // Body settings
        addColor(.bodyColor, theme.primary)
        addColor(.bodyBackground, theme.background)

        // Emphasis colors
        addColor(.emphasisColor, theme.emphasis)
        addColor(.secondaryColor, theme.secondary)
        addColor(.tertiaryColor, theme.tertiary)

        // Background colors
        addColor(.secondaryBackground, theme.secondaryBackground)
        addColor(.tertiaryBackground, theme.tertiaryBackground)

        // Link styles
        addColor(.linkColor, theme.link)
        addColor(.linkHoverColor, theme.linkHover)
        addProperty(.linkDecoration, theme.linkDecoration)

        // Border colors
        addColor(.borderColor, theme.border)

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
        addProperty(.headingsFontWeight, theme.headingFontWeight)
        addProperty(.headingsLineHeight, theme.headingLineHeight)

        // Bottom margins
        addProperty(.headingsMarginBottom, theme.headingBottomMargin)
        addProperty(.paragraphMarginBottom, theme.paragraphBottomMargin)

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

        cssProperties.append("    --syntax-highlight-theme: \"\(theme.syntaxHighlighterTheme.description)\"")

        return cssProperties.joined(separator: ";\n") + ";"
    }
    // swiftlint:enable function_body_length
}
