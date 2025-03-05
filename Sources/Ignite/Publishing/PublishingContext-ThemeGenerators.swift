//
// PublishingContext-ThemeGenerators.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PublishingContext {
    /// Creates CSS rules for all themes and writes to themes.min.css
    func generateThemes(_ themes: [any Theme]) {
        guard !themes.isEmpty else { return }

        let rules = generateThemeRules(themes)
            .map(\.description)
            .joined(separator: "\n\n")

        writeThemeRules(rules, to: "css/ignite-core.min.css")
    }

    /// Writes CSS rules to a file
    private func writeThemeRules(_ rules: String, to path: String) {
        let cssPath = buildDirectory.appending(path: path)
        do {
            let existingContent = try String(contentsOf: cssPath, encoding: .utf8)
            let newContent = existingContent + "\n\n" + rules
            try newContent.write(to: cssPath, atomically: true, encoding: .utf8)
        } catch {
            fatalError(.failedToWriteFile(path))
        }
    }

    /// Generates CSS for all themes including font faces, colors, and typography settings, writing to themes.min.css.
    private func globalRulesets() -> String {
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

    /// Creates @font-face and @import rules for custom fonts in a theme.
    private func fontRules(_ theme: Theme) -> [String] {
        let allFonts = [theme.monospaceFont, theme.font, theme.headingFont] + CSSManager.shared.customFonts
        let systemFonts = Font.systemFonts + Font.monospaceFonts

        let declarations = allFonts.compactMap { font -> [String]? in
            guard let family = font.name, !systemFonts.contains(family) else { return nil }
            return font.sources.compactMap { source in
                generateFontRule(family: family, source: source)?.description
            }
        }

        return Array(OrderedSet(declarations.flatMap { $0 }))
    }

    private func generateFontRule(family: String, source: FontSource) -> CustomStringConvertible? {
        if source.url.host()?.contains("fonts.googleapis.com") == true {
            return ImportRule(source.url)
        }

        return FontFaceRule(
            family: family,
            source: source.url,
            weight: source.weight.description,
            style: source.variant.rawValue
        )
    }

    /// Creates CSS rules for light theme
    private func lightThemeRules(_ theme: Theme, darkThemeID: String?) -> [CustomStringConvertible] {
        var rules: [CustomStringConvertible] = []
        rules.append(lightRootStyles(for: theme, darkThemeID: darkThemeID))
        rules.append(contentsOf: baseThemeRules(theme, otherThemeID: darkThemeID))
        rules.append(contentsOf: themeOverrides(for: theme))
        return rules
    }

    /// Creates CSS rules for dark theme
    private func darkThemeRules(_ theme: Theme, lightThemeID: String?) -> [CustomStringConvertible] {
        var rules: [CustomStringConvertible] = []

        // If this is the only theme, use it as root theme
        if !site.supportsLightTheme, site.alternateThemes.isEmpty {
            rules.append(darkRootStyles(for: theme, lightThemeID: lightThemeID))
            return baseThemeRules(theme, otherThemeID: lightThemeID)
        }

        // Add explicit dark theme override
        rules.append(
            Ruleset(.attribute(name: "data-bs-theme", value: theme.id)) {
                themeStyles(for: theme)
            }
        )

        // Add auto theme dark mode if both themes exist
        if site.supportsLightTheme {
            rules.append(
                MediaQuery(.colorScheme(.dark)) {
                    Ruleset(.attribute(name: "data-bs-theme", value: "auto")) {
                        themeStyles(for: theme)
                    }
                }
            )
        }

        return rules
    }

    /// Collects all CSS rules for the themes
    private func generateThemeRules(_ themes: [any Theme]) -> [CustomStringConvertible] {
        guard site.supportsLightTheme || site.supportsDarkTheme else {
            fatalError(.missingDefaultTheme)
        }

        var rules: [CustomStringConvertible] = []

        let fontRules = themes.flatMap { self.fontRules($0) }
        rules.append(contentsOf: fontRules)

        let (lightTheme, darkTheme) = configureDefaultThemes(site.lightTheme, site.darkTheme)

        if let lightTheme {
            rules.append(contentsOf: lightThemeRules(lightTheme, darkThemeID: darkTheme?.id))
        }

        if let darkTheme {
            rules.append(contentsOf: darkThemeRules(darkTheme, lightThemeID: lightTheme?.id))
        }

        for theme in site.alternateThemes {
            rules.append(
                Ruleset(.attribute(name: "data-bs-theme", value: theme.id)) {
                    themeStyles(for: theme)
                }
            )
        }

        return rules
    }

    /// Configures default light and dark themes, inheriting properties when needed
    private func configureDefaultThemes(_ light: Theme?, _ dark: Theme?) -> (light: Theme?, dark: Theme?) {
        var lightTheme = light
        var darkTheme = dark

        if darkTheme is DefaultDarkTheme, let lightTheme, !lightTheme.isDefaultLightTheme {
            darkTheme = DefaultDarkTheme(siteWidth: lightTheme.siteWidth, breakpoints: lightTheme.breakpoints)
        }

        if lightTheme is DefaultLightTheme, let darkTheme, !darkTheme.isDefaultDarkTheme {
            lightTheme = DefaultLightTheme(siteWidth: darkTheme.siteWidth, breakpoints: darkTheme.breakpoints)
        }

        return (lightTheme, darkTheme)
    }

    /// Creates base theme rules (for root theme)
    private func baseThemeRules(_ theme: Theme, otherThemeID: String?) -> [CustomStringConvertible] {
        var rules: [CustomStringConvertible] = []
        rules.append(contentsOf: responsiveVariables(for: theme))
        rules.append(contentsOf: containerMediaQueries(for: theme))
        rules.append(globalRulesets())
        return rules
    }

    /// Creates theme override rulesets if needed
    private func themeOverrides(for theme: Theme) -> [Ruleset] {
        var overrides: [Ruleset] = []

        if site.hasMultipleThemes {
            overrides.append(
                Ruleset(.attribute(name: "data-bs-theme", value: theme.id)) {
                    themeStyles(for: theme)
                }
            )
        }

        if site.hasAutoTheme {
            overrides.append(
                Ruleset(.attribute(name: "data-bs-theme", value: "auto")) {
                    themeStyles(for: theme)
                }
            )
        }

        return overrides
    }

    /// Contains the various snap dimensions for different Bootstrap widths.
    private func containerMediaQueries(for theme: any Theme) -> [MediaQuery] {
        let breakpoints: [LengthUnit] = [
            theme.siteWidth.values[.small] ?? Bootstrap.smallContainer,
            theme.siteWidth.values[.medium] ?? Bootstrap.mediumContainer,
            theme.siteWidth.values[.large] ?? Bootstrap.largeContainer,
            theme.siteWidth.values[.xLarge] ?? Bootstrap.xLargeContainer,
            theme.siteWidth.values[.xxLarge] ?? Bootstrap.xxLargeContainer
        ]

        return breakpoints.map { minWidth in
            MediaQuery(.breakpoint(minWidth)) {
                Ruleset(.class("container")) {
                    InlineStyle(.maxWidth, value: "\(minWidth)")
                }
            }
        }
    }
}

private extension Site {
    var hasMultipleThemes: Bool {
        supportsDarkTheme || !alternateThemes.isEmpty
    }

    var hasAutoTheme: Bool {
        supportsLightTheme && supportsDarkTheme
    }
}

private extension Theme {
    var isDefaultLightTheme: Bool {
        self is DefaultLightTheme
    }

    var isDefaultDarkTheme: Bool {
        self is DefaultDarkTheme
    }
}
