//
// PublishingContext-ThemeGenerators.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Generates @font-face CSS declarations for custom fonts in a theme, excluding system fonts.
    private func generateFontFaces(_ theme: Theme) -> String {
        let fonts = [
            theme.sansSerifFont,
            theme.monospaceFont,
            theme.font,
            theme.headingFont
        ] + theme.alternateFonts

        var uniqueSources: Set<String> = []

        let fontTags = fonts.flatMap { font -> [String] in
            guard let family = font.name else { return [] }

            // Skip if it's a system font
            guard !Font.systemFonts.contains(family) &&
                  !Font.monospaceFonts.contains(family)
            else {
                return []
            }

            return font.sources.compactMap { source in
                guard let url = source.url else { return nil }

                // Create a unique key for this font source
                let sourceKey = "\(family)-\(source.weight.rawValue)-\(source.variant.rawValue)-\(url.absoluteString)"

                // Skip if we've already processed this source
                guard !uniqueSources.contains(sourceKey) else {
                    return nil
                }

                uniqueSources.insert(sourceKey)

                if url.isFileURL {
                    return """
                    @font-face {
                        font-family: '\(family)';
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
                    font-family: '\(family)';
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
        guard let sourceURL = Bundle.module.url(forResource: "Resources/css/global-rules", withExtension: "css") else {
            fatalError(.missingSiteResource("css/global-rules.css"))
        }

        do {
            let contents = try String(contentsOf: sourceURL)
            return contents
        } catch {
            fatalError(.failedToCopySiteResource("css/global-rules.css"))
        }
    }

    /// Helper to check if a theme matches the default configuration
    private func isDefaultTheme(_ theme: any Theme, defaultTheme: any Theme) -> Bool {
        String(describing: theme) == String(describing: defaultTheme)
    }

    /// Generates CSS for all themes including font faces, colors, and typography settings, writing to themes.min.css.
    func generateThemes(_ themes: [any Theme]) {
        guard !themes.isEmpty else { return }
        var cssContent = ""

        // Generate font faces first
        for theme in themes {
            let fontFaces = generateFontFaces(theme)
            if !fontFaces.isEmpty {
                cssContent += fontFaces + "\n\n"
            }
        }

        guard site.supportsLightTheme || site.supportsDarkTheme else {
            fatalError(.missingDefaultTheme)
        }

        var lightTheme = site.lightTheme
        var darkTheme = site.darkTheme

        // If a site implicitly uses a default theme, have it use the breakpoints
        // and site width's of its opposite theme, if explicity set.
        if darkTheme is DefaultDarkTheme,
           let lightTheme, !isDefaultTheme(lightTheme, defaultTheme: DefaultLightTheme()) {
            darkTheme = DefaultDarkTheme(
                breakpoints: lightTheme.resolvedBreakpoints,
                siteWidths: lightTheme.resolvedSiteWidths)
        }

        if lightTheme is DefaultLightTheme,
           let darkTheme, !isDefaultTheme(darkTheme, defaultTheme: DefaultDarkTheme()) {
            lightTheme = DefaultLightTheme(
                breakpoints: darkTheme.resolvedBreakpoints,
                siteWidths: darkTheme.resolvedSiteWidths)
        }

        if let lightTheme {
            cssContent += generateLightTheme(lightTheme, darkThemeID: darkTheme?.id)
        }

        if let darkTheme {
            cssContent += generateDarkTheme(darkTheme, lightThemeID: lightTheme?.id)
        }

        for theme in site.alternateThemes {
            cssContent += """

            /* Alternate theme: \(theme.name) */
            [data-bs-theme="\(theme.id)"] {
                \(generateThemeVariables(theme))
            }
            """
        }

        let cssPath = buildDirectory.appending(path: "css/ignite-core.min.css")
        do {
            let existingContent = try String(contentsOf: cssPath, encoding: .utf8)
            let newContent = existingContent + "\n\n" + cssContent
            try newContent.write(to: cssPath, atomically: true, encoding: .utf8)
        } catch {
            fatalError(.failedToWriteFile("css/ignite-core.min.css"))
        }
    }

    /// Generates CSS for light theme, returning it to be combined with other theme data.
    private func generateLightTheme(_ lightTheme: Theme, darkThemeID: String?) -> String {
        var output = ""

        // Root variables and default theme (light)
        let hasMultipleThemes = site.supportsDarkTheme || !site.alternateThemes.isEmpty
        let hasAutoTheme = site.supportsLightTheme && site.supportsDarkTheme

        output += """
        :root {
            --supports-light-theme: \(site.supportsLightTheme);
            --supports-dark-theme: \(site.supportsDarkTheme);
            --light-theme-id: "\(lightTheme.id)";
            --dark-theme-id: "\(darkThemeID ?? "")";

            /* Light theme variables (default theme) */
            \(generateThemeVariables(lightTheme))
        }

        \(generateContainers(for: lightTheme))

        \(generateGlobalRules())
        """

        if hasMultipleThemes {
            output += """

            /* Light theme override */
            [data-bs-theme="\(lightTheme.id)"] {
                \(generateThemeVariables(lightTheme))
            }
            """
        }

        if hasAutoTheme {
            output += """

            /* Auto theme starts with light theme */
            [data-bs-theme="auto"] {
                \(generateThemeVariables(lightTheme))
            }
            """
        }

        return output
    }

    /// Generates CSS for dark theme, returning it to be combined with other theme data.
    private func generateDarkTheme(_ darkTheme: Theme, lightThemeID: String?) -> String {
        var output = ""

        if !site.supportsLightTheme && site.alternateThemes.isEmpty {
            // Only dark theme exists and no alternates - use as root
            output += """
            :root {
                --supports-light-theme: \(site.supportsLightTheme);
                --supports-dark-theme: \(site.supportsDarkTheme);
                --light-theme-id: "\(lightThemeID ?? "")";
                --dark-theme-id: "\(darkTheme.id)";

                /* Dark theme variables */
                \(generateThemeVariables(darkTheme))
            }

            \(generateContainers(for: darkTheme))

            \(generateGlobalRules())
            """
        } else {
            // Add dark theme override
            output += """

            /* Explicit dark theme */
            [data-bs-theme="\(darkTheme.id)"] {
                \(generateThemeVariables(darkTheme))
            }
            """

            // Only add auto theme dark mode if both themes exist
            if site.supportsLightTheme {
                output += """

                /* Dark theme media query for auto theme */
                @media (prefers-color-scheme: dark) {
                    [data-bs-theme="auto"] {
                        \(generateThemeVariables(darkTheme))
                    }
                }
                """
            }
        }

        return output
    }

    /// Generates brand and theme color properties
    func generateColorProperties(_ properties: inout [String], for theme: Theme) {
        // Brand colors
        addColor(&properties, .primary, theme.accent, for: theme)
        addColor(&properties, .secondary, theme.secondaryAccent, for: theme)
        addColor(&properties, .success, theme.success, for: theme)
        addColor(&properties, .info, theme.info, for: theme)
        addColor(&properties, .warning, theme.warning, for: theme)
        addColor(&properties, .danger, theme.danger, for: theme)
        addColor(&properties, .light, theme.light, for: theme)
        addColor(&properties, .dark, theme.dark, for: theme)

        // Body settings
        addColor(&properties, .bodyColor, theme.primary, for: theme)
        addColor(&properties, .bodyBackground, theme.background, for: theme)

        // Emphasis colors
        addColor(&properties, .emphasisColor, theme.emphasis, for: theme)
        addColor(&properties, .secondaryColor, theme.secondary, for: theme)
        addColor(&properties, .tertiaryColor, theme.tertiary, for: theme)

        // Background colors
        addColor(&properties, .secondaryBackground, theme.secondaryBackground, for: theme)
        addColor(&properties, .tertiaryBackground, theme.tertiaryBackground, for: theme)

        // Link and border colors
        addColor(&properties, .linkColor, theme.link, for: theme)
        addColor(&properties, .linkHoverColor, theme.linkHover, for: theme)
        addColor(&properties, .borderColor, theme.border, for: theme)
    }

    /// Generates typography-related properties
    func generateTypographyProperties(_ properties: inout [String], for theme: Theme) {
        // Font families
        addFont(&properties, .sansSerifFont, theme.sansSerifFont, defaultFonts: Font.systemFonts)
        addFont(&properties, .monospaceFont, theme.monospaceFont, defaultFonts: Font.monospaceFonts)
        addFont(&properties, .bodyFont, theme.font, defaultFonts: Font.systemFonts)
        addFont(&properties, .headingFont, theme.headingFont, defaultFonts: Font.systemFonts)

        // Font sizes
        addProperty(&properties, .rootFontSize, theme.rootFontSize)
        addProperty(&properties, .bodyFontSize, theme.bodySize)
        addProperty(&properties, .smallBodyFontSize, theme.smallBodySize)
        addProperty(&properties, .largeBodyFontSize, theme.largeBodySize)
        addProperty(&properties, .inlineCodeFontSize, theme.inlineCodeFontSize)
        addProperty(&properties, .codeBlockFontSize, theme.codeBlockFontSize)

        // Heading sizes
        addProperty(&properties, .h1FontSize, theme.xxLargeHeadingSize)
        addProperty(&properties, .h2FontSize, theme.xLargeHeadingSize)
        addProperty(&properties, .h3FontSize, theme.largeHeadingSize)
        addProperty(&properties, .h4FontSize, theme.mediumHeadingSize)
        addProperty(&properties, .h5FontSize, theme.smallHeadingSize)
        addProperty(&properties, .h6FontSize, theme.xSmallHeadingSize)

        // Font weights and line heights
        generateFontWeightProperties(&properties, for: theme)
        generateLineHeightProperties(&properties, for: theme)
    }

    /// Generates font weight properties
    func generateFontWeightProperties(_ properties: inout [String], for theme: Theme) {
        addProperty(&properties, .lighterFontWeight, theme.lighterFontWeight)
        addProperty(&properties, .lightFontWeight, theme.lightFontWeight)
        addProperty(&properties, .normalFontWeight, theme.regularFontWeight)
        addProperty(&properties, .boldFontWeight, theme.boldFontWeight)
        addProperty(&properties, .bolderFontWeight, theme.bolderFontWeight)
    }

    /// Generates line height properties
    func generateLineHeightProperties(_ properties: inout [String], for theme: Theme) {
        addProperty(&properties, .bodyLineHeight, theme.lineHeight)
        addProperty(&properties, .condensedLineHeight, theme.smallLineHeight)
        addProperty(&properties, .expandedLineHeight, theme.largeLineHeight)
        addProperty(&properties, .headingsLineHeight, theme.headingLineHeight)
    }

    /// Generates CSS variables for a theme
    func generateThemeVariables(_ theme: Theme) -> String {
        var cssProperties: [String] = []

        generateColorProperties(&cssProperties, for: theme)
        generateTypographyProperties(&cssProperties, for: theme)

        // Link decoration
        addProperty(&cssProperties, .linkDecoration, theme.linkDecoration)

        // Margins
        addProperty(&cssProperties, .headingsMarginBottom, theme.headingBottomMargin)
        addProperty(&cssProperties, .paragraphMarginBottom, theme.paragraphBottomMargin)

        // Resolve and add breakpoint values
        addWidthProperties(&cssProperties, theme)
        addBreakpointProperties(&cssProperties, theme)

        cssProperties.append("    --syntax-highlight-theme: \"\(theme.syntaxHighlighterTheme.description)\"")

        return cssProperties.joined(separator: ";\n") + ";"
    }

    /// Adds resolved container size properties to CSS properties array
    func addWidthProperties(_ properties: inout [String], _ theme: any Theme) {
        let resolved = resolveSiteWidths(for: theme)
        properties.append("    \(BootstrapVariable.smallContainer): \(resolved.small)")
        properties.append("    \(BootstrapVariable.mediumContainer): \(resolved.medium)")
        properties.append("    \(BootstrapVariable.largeContainer): \(resolved.large)")
        properties.append("    \(BootstrapVariable.xLargeContainer): \(resolved.xLarge)")
        properties.append("    \(BootstrapVariable.xxLargeContainer): \(resolved.xxLarge)")
    }

    /// Adds resolved breakpoint size properties to CSS properties array
    func addBreakpointProperties(_ properties: inout [String], _ theme: any Theme) {
        let resolved = resolveBreakpoints(for: theme)
        properties.append("    \(BootstrapVariable.smallBreakpoint): \(resolved.small)")
        properties.append("    \(BootstrapVariable.mediumBreakpoint): \(resolved.medium)")
        properties.append("    \(BootstrapVariable.largeBreakpoint): \(resolved.large)")
        properties.append("    \(BootstrapVariable.xLargeBreakpoint): \(resolved.xLarge)")
        properties.append("    \(BootstrapVariable.xxLargeBreakpoint): \(resolved.xxLarge)")
    }
}
