//
// PublishingContext-ThemeGenerators.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Generates @font-face CSS declarations for custom fonts in a theme, excluding system fonts.
    private func generateFontFaces(_ theme: any Theme) -> String {
        let fonts = [
            theme.code.font,
            theme.text.font,
            theme.headings.font
        ] + CSSManager.shared.customFonts

        var uniqueSources: Set<String> = []

        let fontTags = fonts.compactMap(\.self).flatMap { font -> [String] in
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
                breakpoints: lightTheme.breakpoints,
                siteWidths: lightTheme.siteWidths)
        }

        if lightTheme is DefaultLightTheme,
           let darkTheme, !isDefaultTheme(darkTheme, defaultTheme: DefaultDarkTheme()) {
            lightTheme = DefaultLightTheme(
                breakpoints: darkTheme.breakpoints,
                siteWidths: darkTheme.siteWidths)
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

            \(generateResponsiveTextRules(theme))
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
    private func generateLightTheme(_ lightTheme: any Theme, darkThemeID: String?) -> String {
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

        \(generateResponsiveTextRules(lightTheme))

        \(generateContainers(for: lightTheme))

        \(generateGlobalRules())
        """

        if hasMultipleThemes {
            output += """

            /* Light theme override */
            [data-bs-theme="\(lightTheme.id)"] {
                \(generateThemeVariables(lightTheme))
            }

            \(generateResponsiveTextRules(lightTheme))
            """
        }

        if hasAutoTheme {
            output += """

            /* Auto theme starts with light theme */
            [data-bs-theme="auto"] {
                \(generateThemeVariables(lightTheme))
            }

            \(generateResponsiveTextRules(lightTheme))
            """
        }

        return output
    }

    /// Generates CSS for dark theme, returning it to be combined with other theme data.
    private func generateDarkTheme(_ darkTheme: any Theme, lightThemeID: String?) -> String {
        var output = ""

        if !site.supportsLightTheme && site.alternateThemes.isEmpty {
            output += """
            :root {
                --supports-light-theme: \(site.supportsLightTheme);
                --supports-dark-theme: \(site.supportsDarkTheme);
                --light-theme-id: "\(lightThemeID ?? "")";
                --dark-theme-id: "\(darkTheme.id)";

                /* Dark theme variables */
                \(generateThemeVariables(darkTheme))
            }

            \(generateResponsiveTextRules(darkTheme))

            \(generateContainers(for: darkTheme))

            \(generateGlobalRules())
            """
        } else {
            output += """

            /* Explicit dark theme */
            [data-bs-theme="\(darkTheme.id)"] {
                \(generateThemeVariables(darkTheme))
            }

            \(generateResponsiveTextRules(darkTheme))
            """

            // Only add auto theme dark mode if both themes exist
            if site.supportsLightTheme {
                output += """

                /* Dark theme media query for auto theme */
                @media (prefers-color-scheme: dark) {
                    [data-bs-theme="auto"] {
                        \(generateThemeVariables(darkTheme))
                    }

                    \(generateResponsiveTextRules(darkTheme))
                }
                """
            }
        }

        return output
    }

    /// Generates brand and theme color properties
    func generateColorProperties(_ properties: inout [String], for theme: any Theme) {
        // Theme colors
        addColor(&properties, .primary, theme.colorPalette.accent, for: theme)
        addColor(&properties, .secondary, theme.colorPalette.secondaryAccent, for: theme)
        addColor(&properties, .success, theme.colorPalette.success, for: theme)
        addColor(&properties, .info, theme.colorPalette.info, for: theme)
        addColor(&properties, .warning, theme.colorPalette.warning, for: theme)
        addColor(&properties, .danger, theme.colorPalette.danger, for: theme)
        addColor(&properties, .light, theme.colorPalette.offWhite, for: theme)
        addColor(&properties, .dark, theme.colorPalette.offBlack, for: theme)
        addColor(&properties, .borderColor, theme.colorPalette.border, for: theme)

        // Text colors
        addColor(&properties, .bodyColor, theme.text.color, for: theme)
        addColor(&properties, .emphasisColor, theme.colorPalette.emphasis, for: theme)
        addColor(&properties, .secondaryColor, theme.colorPalette.secondaryText, for: theme)
        addColor(&properties, .tertiaryColor, theme.colorPalette.tertiaryText, for: theme)

        // Background colors
        addColor(&properties, .bodyBackground, theme.colorPalette.background, for: theme)
        addColor(&properties, .secondaryBackground, theme.colorPalette.secondaryBackground, for: theme)
        addColor(&properties, .tertiaryBackground, theme.colorPalette.tertiaryBackground, for: theme)

        // Link and border colors
        addColor(&properties, .linkColor, theme.links.normal, for: theme)
        addColor(&properties, .linkHoverColor, theme.links.hover, for: theme)
    }

    func generateTypographyProperties(_ properties: inout [String], for theme: any Theme) {
        // Font families
        addFont(&properties, .monospaceFont, theme.code.font, defaultFonts: Font.monospaceFonts)
        addFont(&properties, .bodyFont, theme.text.font, defaultFonts: Font.systemFonts)
        addFont(&properties, .headingFont, theme.headings.font, defaultFonts: Font.systemFonts)

        // Base font sizes
        addProperty(&properties, .rootFontSize, theme.rootFontSize)
        addProperty(&properties, .inlineCodeFontSize, theme.code.inlineSize)
        addProperty(&properties, .codeBlockFontSize, theme.code.blockSize)

        // Base text sizes (xSmall breakpoint)
        if let textSizes = theme.text.sizes {
            addProperty(&properties, .bodyFontSize, textSizes.xSmall)
        }

        // Base heading sizes (xSmall breakpoint)
        if let headingSizes = theme.headings.sizes {
            addProperty(&properties, .h1FontSize, headingSizes.h1?.xSmall)
            addProperty(&properties, .h2FontSize, headingSizes.h2?.xSmall)
            addProperty(&properties, .h3FontSize, headingSizes.h3?.xSmall)
            addProperty(&properties, .h4FontSize, headingSizes.h4?.xSmall)
            addProperty(&properties, .h5FontSize, headingSizes.h5?.xSmall)
            addProperty(&properties, .h6FontSize, headingSizes.h6?.xSmall)
        }

        // Font weights and line heights
        addProperty(&properties, .bodyLineHeight, theme.text.lineSpacing)
        addProperty(&properties, .headingsLineHeight, theme.headings.lineHeight)
    }

    private func generateResponsiveTextRules(_ theme: any Theme) -> String {
        var rules: [String] = []

        // Add responsive text sizes
        if let textSizes = theme.text.sizes {
            addBodyFontSizes(&rules, textSizes)
        }

        // Add responsive heading sizes
        if let headingSizes = theme.headings.sizes {
            addH1FontSizes(&rules, headingSizes)
            addH2FontSizes(&rules, headingSizes)
            addH3FontSizes(&rules, headingSizes)
            addH4FontSizes(&rules, headingSizes)
            addH5FontSizes(&rules, headingSizes)
            addH6FontSizes(&rules, headingSizes)
        }

        return rules.joined(separator: "\n\n")
    }

    /// Generates CSS variables for a theme
    func generateThemeVariables(_ theme: any Theme) -> String {
        var cssProperties: [String] = []

        generateColorProperties(&cssProperties, for: theme)
        generateTypographyProperties(&cssProperties, for: theme)

        // Link decoration
        addProperty(&cssProperties, .linkDecoration, theme.links.decoration)

        // Margins
        addProperty(&cssProperties, .headingsMarginBottom, theme.headings.bottomMargin)
        addProperty(&cssProperties, .paragraphMarginBottom, theme.text.bottomMargin)

        // Resolve and add breakpoint values
        addWidthProperties(&cssProperties, theme)
        addBreakpointProperties(&cssProperties, theme)

        if let highlighterTheme = theme.code.syntaxHighlighterTheme {
            cssProperties.append("    --syntax-highlight-theme: \"\(highlighterTheme.description)\"")
        }

        return cssProperties.joined(separator: ";\n") + ";"
    }

    /// Adds resolved container size properties to CSS properties array
    func addWidthProperties(_ properties: inout [String], _ theme: any Theme) {
        properties.append("    \(BootstrapVariable.smallContainer): \(theme.siteWidths.small)")
        properties.append("    \(BootstrapVariable.mediumContainer): \(theme.siteWidths.medium)")
        properties.append("    \(BootstrapVariable.largeContainer): \(theme.siteWidths.large)")
        properties.append("    \(BootstrapVariable.xLargeContainer): \(theme.siteWidths.xLarge)")
        properties.append("    \(BootstrapVariable.xxLargeContainer): \(theme.siteWidths.xxLarge)")
    }

    /// Adds resolved breakpoint size properties to CSS properties array
    func addBreakpointProperties(_ properties: inout [String], _ theme: any Theme) {
        properties.append("    \(BootstrapVariable.smallBreakpoint): \(theme.breakpoints.small)")
        properties.append("    \(BootstrapVariable.mediumBreakpoint): \(theme.breakpoints.medium)")
        properties.append("    \(BootstrapVariable.largeBreakpoint): \(theme.breakpoints.large)")
        properties.append("    \(BootstrapVariable.xLargeBreakpoint): \(theme.breakpoints.xLarge)")
        properties.append("    \(BootstrapVariable.xxLargeBreakpoint): \(theme.breakpoints.xxLarge)")
    }
}
