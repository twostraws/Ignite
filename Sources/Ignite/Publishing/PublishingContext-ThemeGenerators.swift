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
            theme.monospaceFont,
            theme.font,
            theme.headingFont
        ] + CSSManager.shared.customFonts

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
            darkTheme = DefaultDarkTheme(siteWidth: lightTheme.siteWidth, breakpoints: lightTheme.breakpoints)
        }

        if lightTheme is DefaultLightTheme,
           let darkTheme, !isDefaultTheme(darkTheme, defaultTheme: DefaultDarkTheme()) {
            lightTheme = DefaultLightTheme(siteWidth: darkTheme.siteWidth, breakpoints: darkTheme.breakpoints)
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

        \(generateResponsiveVariables(lightTheme))

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

            \(generateResponsiveVariables(darkTheme))

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

    /// Generates CSS variables for a theme
    func generateThemeVariables(_ theme: Theme) -> String {
        var cssProperties: [String] = []

        generateColorProperties(&cssProperties, for: theme)
        generateTypographyProperties(&cssProperties, for: theme)
        addProperty(&cssProperties, .linkDecoration, theme.linkDecoration)
        addProperty(&cssProperties, .headingsMarginBottom, theme.headingBottomMargin)
        addProperty(&cssProperties, .paragraphMarginBottom, theme.paragraphBottomMargin)
        addWidthProperties(&cssProperties, theme)
        addBreakpointProperties(&cssProperties, theme)

        cssProperties.append("    --syntax-highlight-theme: \"\(theme.syntaxHighlighterTheme.description)\"")

        return cssProperties.joined(separator: ";\n") + ";"
    }

    /// Generates brand and theme color properties
    func generateColorProperties(_ properties: inout [String], for theme: Theme) {
        addColor(&properties, .primary, theme.accent, for: theme)
        addColor(&properties, .secondary, theme.secondaryAccent, for: theme)
        addColor(&properties, .success, theme.success, for: theme)
        addColor(&properties, .info, theme.info, for: theme)
        addColor(&properties, .warning, theme.warning, for: theme)
        addColor(&properties, .danger, theme.danger, for: theme)
        addColor(&properties, .light, theme.offWhite, for: theme)
        addColor(&properties, .dark, theme.offBlack, for: theme)

        addColor(&properties, .bodyColor, theme.primary, for: theme)
        addColor(&properties, .bodyBackground, theme.background, for: theme)

        addColor(&properties, .emphasisColor, theme.emphasis, for: theme)
        addColor(&properties, .secondaryColor, theme.secondary, for: theme)
        addColor(&properties, .tertiaryColor, theme.tertiary, for: theme)

        addColor(&properties, .secondaryBackground, theme.secondaryBackground, for: theme)
        addColor(&properties, .tertiaryBackground, theme.tertiaryBackground, for: theme)

        addColor(&properties, .linkColor, theme.link, for: theme)
        addColor(&properties, .linkHoverColor, theme.hoveredLink, for: theme)
        addColor(&properties, .borderColor, theme.border, for: theme)
    }

    /// Generates typography-related properties
    func generateTypographyProperties(_ properties: inout [String], for theme: Theme) {
        addFont(&properties, .monospaceFont, theme.monospaceFont, defaultFonts: Font.monospaceFonts)
        addFont(&properties, .bodyFont, theme.font, defaultFonts: Font.systemFonts)
        addFont(&properties, .headingFont, theme.headingFont, defaultFonts: Font.systemFonts)

        addProperty(&properties, .rootFontSize, theme.rootFontSize)
        addProperty(&properties, .inlineCodeFontSize, theme.inlineCodeFontSize)
        addProperty(&properties, .codeBlockFontSize, theme.codeBlockFontSize)
        addFontSize(&properties, .bodyFontSize, theme.bodyFontSize)
        addFontSize(&properties, .h1FontSize, theme.h1Size)
        addFontSize(&properties, .h2FontSize, theme.h2Size)
        addFontSize(&properties, .h3FontSize, theme.h3Size)
        addFontSize(&properties, .h4FontSize, theme.h4Size)
        addFontSize(&properties, .h5FontSize, theme.h5Size)
        addFontSize(&properties, .h6FontSize, theme.h6Size)

        addProperty(&properties, .bodyLineHeight, theme.lineSpacing)
        addProperty(&properties, .headingsLineHeight, theme.headingLineSpacing)
    }

    /// Generates the media queries to update font size variables at different breakpoints
    private func generateResponsiveVariables(_ theme: Theme) -> String {
        var output = ""
        let breakpoints: [Breakpoint] = [.small, .medium, .large, .xLarge, .xxLarge]
        let fontSizes: [(BootstrapVariable, ResponsiveValues<LengthUnit>)] = [
            (.bodyFontSize, theme.bodyFontSize),
            (.h1FontSize, theme.h1Size),
            (.h2FontSize, theme.h2Size),
            (.h3FontSize, theme.h3Size),
            (.h4FontSize, theme.h4Size),
            (.h5FontSize, theme.h5Size),
            (.h6FontSize, theme.h6Size)
        ]

        for breakpoint in breakpoints {
            var properties: [String] = []

            for (variable, sizes) in fontSizes {
                addFontSize(&properties, variable, sizes, breakpoint)
            }

            if !properties.isEmpty {
                output += """

                @media (min-width: var(--bs-breakpoint-\(breakpoint.infix!))) {
                    :root {
                        \(properties.joined(separator: ";\n"))
                    }
                }
                """
            }
        }

        return output
    }
}
