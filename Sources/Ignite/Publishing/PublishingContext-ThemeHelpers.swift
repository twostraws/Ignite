//
// PublishingContext-ThemeHelpers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension PublishingContext {
    /// Creates the root ruleset for a theme
    func rootStyles(for theme: any Theme) -> Ruleset {
        Ruleset(.pseudoClass("root")) {
            themeStyles(for: theme)
        }
    }

    /// Creates all theme-specific CSS styles
    func themeStyles(for theme: any Theme) -> [InlineStyle] {
        var styles: [InlineStyle?] = []

        styles.append(contentsOf: colorStyles(for: theme))
        styles.append(contentsOf: typographyStyles(for: theme))

        styles.append(contentsOf: [
            InlineStyle(.linkDecoration, value: theme.linkDecoration),
            InlineStyle(.headingsMarginBottom, value: theme.headingBottomMargin),
            InlineStyle(.paragraphMarginBottom, value: theme.paragraphBottomMargin)
        ])

        styles.append(contentsOf: widthStyles(theme))
        styles.append(contentsOf: breakpointStyles(theme))

        styles.append(.init(
            "--syntax-highlight-theme",
            value: "\"\(theme.syntaxHighlighterTheme.description)\""
        ))

        return styles.compactMap { $0 }
    }

    /// Generates the media queries to update font size variables at different breakpoints
    func responsiveVariables(for theme: any Theme) -> [MediaQuery] {
        let breakpoints: [(Breakpoint, LengthUnit)] = [
            (.small, theme.breakpoints.values[.small] ?? Bootstrap.smallBreakpoint),
            (.medium, theme.breakpoints.values[.medium] ?? Bootstrap.mediumBreakpoint),
            (.large, theme.breakpoints.values[.large] ?? Bootstrap.largeBreakpoint),
            (.xLarge, theme.breakpoints.values[.xLarge] ?? Bootstrap.xLargeBreakpoint),
            (.xxLarge, theme.breakpoints.values[.xxLarge] ?? Bootstrap.xxLargeBreakpoint)
        ]

        let fontSizes: [(BootstrapVariable, ResponsiveValues<LengthUnit>)] = [
            (.bodyFontSize, theme.bodyFontSize),
            (.h1FontSize, theme.h1Size),
            (.h2FontSize, theme.h2Size),
            (.h3FontSize, theme.h3Size),
            (.h4FontSize, theme.h4Size),
            (.h5FontSize, theme.h5Size),
            (.h6FontSize, theme.h6Size)
        ]

        return breakpoints.compactMap { breakpoint, minWidth in
            let styles = fontSizes.compactMap { variable, sizes -> InlineStyle? in
                guard let size = sizes.values[breakpoint] else { return nil }
                return InlineStyle(variable, value: size)
            }

            // Only create media query if we have non-empty styles
            guard !styles.isEmpty, styles.allSatisfy({ !$0.value.isEmpty }) else { return nil }

            return MediaQuery(.breakpoint(.custom(minWidth))) {
                Ruleset(.pseudoClass("root")) {
                    styles
                }
            }
        }
    }

    /// Creates responsive measurement styles
    private func createResponsiveStyles(
        from values: ResponsiveValues<LengthUnit>,
        using variables: [(Breakpoint, BootstrapVariable)]
    ) -> [InlineStyle] {
        variables.compactMap { breakpoint, variable in
            guard let value = values.values[breakpoint] else { return nil }
            return InlineStyle(variable, value: value)
        }
    }

    private func widthStyles(_ theme: any Theme) -> [InlineStyle] {
        let variables: [(Breakpoint, BootstrapVariable)] = [
            (.small, .smallContainer),
            (.medium, .mediumContainer),
            (.large, .largeContainer),
            (.xLarge, .xLargeContainer),
            (.xxLarge, .xxLargeContainer)
        ]
        return createResponsiveStyles(from: theme.siteWidth, using: variables)
    }

    private func breakpointStyles(_ theme: any Theme) -> [InlineStyle] {
        let variables: [(Breakpoint, BootstrapVariable)] = [
            (.small, .smallBreakpoint),
            (.medium, .mediumBreakpoint),
            (.large, .largeBreakpoint),
            (.xLarge, .xLargeBreakpoint),
            (.xxLarge, .xxLargeBreakpoint)
        ]
        return createResponsiveStyles(from: theme.breakpoints, using: variables)
    }

    /// Creates color-related CSS styles for a theme
    private func colorStyles(for theme: any Theme) -> [InlineStyle] {
        let brandColors: [(BootstrapVariable, Color)] = [
            (.primary, theme.accent),
            (.secondary, theme.secondaryAccent),
            (.success, theme.success),
            (.info, theme.info),
            (.warning, theme.warning),
            (.danger, theme.danger),
            (.light, theme.offWhite),
            (.dark, theme.offBlack)
        ]

        let themeColors: [(BootstrapVariable, Color)] = [
            (.bodyColor, theme.primary),
            (.bodyBackground, theme.background),
            (.emphasisColor, theme.emphasis),
            (.secondaryColor, theme.secondary),
            (.tertiaryColor, theme.tertiary),
            (.secondaryBackground, theme.secondaryBackground),
            (.tertiaryBackground, theme.tertiaryBackground),
            (.linkColor, theme.link),
            (.linkHoverColor, theme.hoveredLink),
            (.borderColor, theme.border)
        ]

        return (brandColors + themeColors).flatMap { variable, color -> [InlineStyle] in
            var styles: [InlineStyle?] = [
                InlineStyle(variable, value: color),
                InlineStyle("\(variable)-rgb", value: "\(color.red), \(color.green), \(color.blue)")
            ]

            if variable.isThemeColor {
                styles.append(contentsOf: colorVariants(variable, color, for: theme))
            }

            return styles.compactMap { $0 }
        }
    }

    /// Creates color variant styles for a theme color
    private func colorVariants(_ variable: BootstrapVariable, _ color: Color, for theme: any Theme) -> [InlineStyle] {
        let bgSubtleColor = theme.colorScheme == .dark ? color.weighted(.darkest) : color.weighted(.lightest)
        var emphasisColor = theme.colorScheme == .dark ? color.weighted(.light) : color.weighted(.darker)
        var borderSubtleColor = theme.colorScheme == .dark ? color.weighted(.dark) : color.weighted(.light)

        switch variable {
        case .dark where theme.colorScheme == .dark:
            borderSubtleColor = color.weighted(.semiLight)
            emphasisColor = color.weighted(.lightest)
        case .light where theme.colorScheme == .dark:
            borderSubtleColor = color.weighted(.darker)
        case .light:
            borderSubtleColor = color.weighted(.semiDark)
            emphasisColor = color.weighted(.darkest)
        default: break
        }

        return [
            InlineStyle("\(variable.rawValue)-text-emphasis", value: emphasisColor.description),
            InlineStyle("\(variable.rawValue)-bg-subtle", value: bgSubtleColor.description),
            InlineStyle("\(variable.rawValue)-border-subtle", value: borderSubtleColor.description)
        ]
    }

    /// Creates typography-related CSS styles for a theme
    private func typographyStyles(for theme: any Theme) -> [InlineStyle] {
        var styles: [InlineStyle] = []

        let fonts: [(BootstrapVariable, Font)] = [
            (.monospaceFont, theme.monospaceFont),
            (.bodyFont, theme.font),
            (.headingFont, theme.headingFont)
        ]

        styles.append(contentsOf: fonts.compactMap {
            InlineStyle($0, value: $1)
        })

        let fontSizes: [(BootstrapVariable, any Defaultable)] = [
            (.rootFontSize, theme.rootFontSize),
            (.inlineCodeFontSize, theme.inlineCodeFontSize),
            (.codeBlockFontSize, theme.codeBlockFontSize),
            (.bodyFontSize, theme.bodyFontSize),
            (.h1FontSize, theme.h1Size),
            (.h2FontSize, theme.h2Size),
            (.h3FontSize, theme.h3Size),
            (.h4FontSize, theme.h4Size),
            (.h5FontSize, theme.h5Size),
            (.h6FontSize, theme.h6Size)
        ]

        styles.append(contentsOf: fontSizes.compactMap {
            if let responsiveValues = $1 as? ResponsiveValues<LengthUnit> {
                return InlineStyle($0, value: responsiveValues.values[.xSmall] ?? .default)
            }
            return InlineStyle($0, value: $1)
        })

        let lineHeights: [(BootstrapVariable, any Defaultable)] = [
            (.bodyLineHeight, theme.lineSpacing),
            (.headingsLineHeight, theme.headingLineSpacing)
        ]

        styles.append(contentsOf: lineHeights.compactMap {
            InlineStyle($0, value: $1)
        })

        if let headingFontWeight = InlineStyle(.headingsFontWeight, value: theme.headingFontWeight) {
            styles.append(headingFontWeight)
        }

        return styles
    }
}

private extension InlineStyle {
    init?(_ variable: BootstrapVariable, value: any Defaultable) {
        guard !value.isDefault else { return nil }
        self.property = variable.rawValue
        self.value = String(describing: value)
    }
}
