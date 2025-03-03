//
// PublishingContext-ThemeHelpers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension PublishingContext {
    /// Adds a CSS property if the value is not default
    func addProperty(_ properties: inout [String], _ variable: BootstrapVariable, _ value: AnyHashable?) {
        if let value {
            properties.append("    \(variable.rawValue): \(value)")
        }
    }

    /// Adds color properties including RGB and theme variants
    func addColor(_ properties: inout [String], _ variable: BootstrapVariable, _ color: Color?, for theme: any Theme) {
        if let color {
            properties.append("    \(variable.rawValue): \(color)")
            properties.append("    \(variable.rawValue)-rgb: \(color.red), \(color.green), \(color.blue)")

            if variable.isThemeColor {
                addColorVariants(&properties, variable, color, for: theme)
            }
        }
    }

    /// Adds subtle background, border, and text emphasis variants for theme colors
    func addColorVariants(
        _ properties: inout [String],
        _ variable: BootstrapVariable,
        _ color: Color, for theme: any Theme
    ) {
        let bgSubtleColor = theme is (any DarkTheme) ? color.weighted(.darkest) : color.weighted(.lightest)
        var emphasisColor = theme is (any DarkTheme) ? color.weighted(.light) : color.weighted(.darker)
        var borderSubtleColor = theme is (any DarkTheme) ? color.weighted(.dark) : color.weighted(.light)

        // Special handling for dark and light roles
        switch variable {
        case .dark where theme is (any DarkTheme):
            borderSubtleColor = color.weighted(.semiLight)
            emphasisColor = color.weighted(.lightest)
        case .light where theme is (any DarkTheme):
            borderSubtleColor = color.weighted(.darker)
        case .light:
            borderSubtleColor = color.weighted(.semiDark)
            emphasisColor = color.weighted(.darkest)
        default: break
        }

        properties.append("    \(variable.rawValue)-text-emphasis: \(emphasisColor)")
        properties.append("    \(variable.rawValue)-bg-subtle: \(bgSubtleColor)")
        properties.append("    \(variable.rawValue)-border-subtle: \(borderSubtleColor)")
    }

    /// Adds font properties with fallback to default fonts
    func addFont(_ properties: inout [String], _ variable: BootstrapVariable, _ font: Font?, defaultFonts: [String]) {
        if let font {
            properties.append("    \(variable.rawValue): \(font.name ?? defaultFonts.joined(separator: ","))")
        }
    }

    /// Adds a responsive CSS property that only applies at a specific breakpoint
    private func addResponsiveProperty(
        _ properties: inout [String],
        _ variable: BootstrapVariable,
        _ value: LengthUnit?,
        _ breakpoint: BootstrapVariable
    ) {
        guard let value else { return }
        properties.append("""
            @media (min-width: var(\(breakpoint))) {
                \(variable): \(value);
            }
        """)
    }

    func addBodyFontSizes(_ properties: inout [String], _ sizes: ResponsiveValues<LengthUnit>) {
        addResponsiveProperty(&properties, .bodyFontSize, sizes.small, .smallBreakpoint)
        addResponsiveProperty(&properties, .bodyFontSize, sizes.medium, .mediumBreakpoint)
        addResponsiveProperty(&properties, .bodyFontSize, sizes.large, .largeBreakpoint)
        addResponsiveProperty(&properties, .bodyFontSize, sizes.xLarge, .xLargeBreakpoint)
        addResponsiveProperty(&properties, .bodyFontSize, sizes.xxLarge, .xxLargeBreakpoint)
    }

    func addH1FontSizes(_ properties: inout [String], _ sizes: HeadingSizes) {
        addResponsiveProperty(&properties, .h1FontSize, sizes.h1?.small, .smallBreakpoint)
        addResponsiveProperty(&properties, .h1FontSize, sizes.h1?.medium, .mediumBreakpoint)
        addResponsiveProperty(&properties, .h1FontSize, sizes.h1?.large, .largeBreakpoint)
        addResponsiveProperty(&properties, .h1FontSize, sizes.h1?.xLarge, .xLargeBreakpoint)
        addResponsiveProperty(&properties, .h1FontSize, sizes.h1?.xxLarge, .xxLargeBreakpoint)
    }

    func addH2FontSizes(_ properties: inout [String], _ sizes: HeadingSizes) {
        addResponsiveProperty(&properties, .h2FontSize, sizes.h2?.small, .smallBreakpoint)
        addResponsiveProperty(&properties, .h2FontSize, sizes.h2?.medium, .mediumBreakpoint)
        addResponsiveProperty(&properties, .h2FontSize, sizes.h2?.large, .largeBreakpoint)
        addResponsiveProperty(&properties, .h2FontSize, sizes.h2?.xLarge, .xLargeBreakpoint)
        addResponsiveProperty(&properties, .h2FontSize, sizes.h2?.xxLarge, .xxLargeBreakpoint)
    }

    func addH3FontSizes(_ properties: inout [String], _ sizes: HeadingSizes) {
        addResponsiveProperty(&properties, .h3FontSize, sizes.h3?.small, .smallBreakpoint)
        addResponsiveProperty(&properties, .h3FontSize, sizes.h3?.medium, .mediumBreakpoint)
        addResponsiveProperty(&properties, .h3FontSize, sizes.h3?.large, .largeBreakpoint)
        addResponsiveProperty(&properties, .h3FontSize, sizes.h3?.xLarge, .xLargeBreakpoint)
        addResponsiveProperty(&properties, .h3FontSize, sizes.h3?.xxLarge, .xxLargeBreakpoint)
    }

    func addH4FontSizes(_ properties: inout [String], _ sizes: HeadingSizes) {
        addResponsiveProperty(&properties, .h4FontSize, sizes.h4?.small, .smallBreakpoint)
        addResponsiveProperty(&properties, .h4FontSize, sizes.h4?.medium, .mediumBreakpoint)
        addResponsiveProperty(&properties, .h4FontSize, sizes.h4?.large, .largeBreakpoint)
        addResponsiveProperty(&properties, .h4FontSize, sizes.h4?.xLarge, .xLargeBreakpoint)
        addResponsiveProperty(&properties, .h4FontSize, sizes.h4?.xxLarge, .xxLargeBreakpoint)
    }

    func addH5FontSizes(_ properties: inout [String], _ sizes: HeadingSizes) {
        addResponsiveProperty(&properties, .h5FontSize, sizes.h5?.small, .smallBreakpoint)
        addResponsiveProperty(&properties, .h5FontSize, sizes.h5?.medium, .mediumBreakpoint)
        addResponsiveProperty(&properties, .h5FontSize, sizes.h5?.large, .largeBreakpoint)
        addResponsiveProperty(&properties, .h5FontSize, sizes.h5?.xLarge, .xLargeBreakpoint)
        addResponsiveProperty(&properties, .h5FontSize, sizes.h5?.xxLarge, .xxLargeBreakpoint)
    }

    func addH6FontSizes(_ properties: inout [String], _ sizes: HeadingSizes) {
        addResponsiveProperty(&properties, .h6FontSize, sizes.h6?.small, .smallBreakpoint)
        addResponsiveProperty(&properties, .h6FontSize, sizes.h6?.medium, .mediumBreakpoint)
        addResponsiveProperty(&properties, .h6FontSize, sizes.h6?.large, .largeBreakpoint)
        addResponsiveProperty(&properties, .h6FontSize, sizes.h6?.xLarge, .xLargeBreakpoint)
        addResponsiveProperty(&properties, .h6FontSize, sizes.h6?.xxLarge, .xxLargeBreakpoint)
    }
}
