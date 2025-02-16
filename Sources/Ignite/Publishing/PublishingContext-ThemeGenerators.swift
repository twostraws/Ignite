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
            theme.codeFont,
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

        if let theme = site.lightTheme {
            cssContent += generateLightTheme(using: theme)
        }

        if let theme = site.darkTheme {
            cssContent += generateDarkTheme(using: theme)
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
        do {
            try cssContent.write(to: cssPath, atomically: true, encoding: .utf8)
        } catch {
            fatalError(.failedToWriteFile("css/themes.min.css"))
        }
    }

    /// Generates CSS for light theme, returning it to be combined with other theme data.
    private func generateLightTheme(using theme: Theme) -> String {
        var output = ""

        // Root variables and default theme (light)
        let hasMultipleThemes = site.supportsDarkTheme || !site.alternateThemes.isEmpty
        let hasAutoTheme = site.supportsLightTheme && site.supportsDarkTheme

        output += """
        :root {
            --supports-light-theme: \(site.supportsLightTheme);
            --supports-dark-theme: \(site.supportsDarkTheme);
            --light-theme-id: "\(site.lightTheme?.id ?? "")";
            --dark-theme-id: "\(site.darkTheme?.id ?? "")";

            /* Light theme variables (default theme) */
            \(generateThemeVariables(theme))
        }

        \(containerDefaults)

        \(generateGlobalRules())
        """

        if hasMultipleThemes {
            output += """

            /* Light theme override */
            [data-bs-theme="\(theme.id)"] {
                \(generateThemeVariables(theme))
            }
            """
        }

        if hasAutoTheme {
            output += """

            /* Auto theme starts with light theme */
            [data-bs-theme="auto"] {
                \(generateThemeVariables(theme))
            }
            """
        }

        return output
    }

    /// Generates CSS for dark theme, returning it to be combined with other theme data.
    private func generateDarkTheme(using theme: Theme) -> String {
        var output = ""

        if !site.supportsLightTheme && site.alternateThemes.isEmpty {
            // Only dark theme exists and no alternates - use as root
            output += """
            :root {
                --supports-light-theme: \(site.supportsLightTheme);
                --supports-dark-theme: \(site.supportsDarkTheme);
                --light-theme-id: "\(site.lightTheme?.id ?? "")";
                --dark-theme-id: "\(site.darkTheme?.id ?? "")";

                /* Dark theme variables */
                \(generateThemeVariables(theme))
            }

            \(containerDefaults)

            \(generateGlobalRules())
            """
        } else {
            // Add dark theme override
            output += """

            /* Explicit dark theme */
            [data-bs-theme="\(theme.id)"] {
                \(generateThemeVariables(theme))
            }
            """

            // Only add auto theme dark mode if both themes exist
            if site.supportsLightTheme {
                output += """

                /* Dark theme media query for auto theme */
                @media (prefers-color-scheme: dark) {
                    [data-bs-theme="auto"] {
                        \(generateThemeVariables(theme))
                    }
                }
                """
            }
        }

        return output
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
