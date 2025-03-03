//
// PublishingContext-ThemeHelpers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension PublishingContext {
    private struct BreakpointValue {
        let size: Breakpoint
        let variable: BootstrapVariable
        let fallback: LengthUnit
    }

    /// Appends container width CSS variables for each breakpoint to the properties array.
    func addWidthProperties(_ properties: inout [String], _ theme: any Theme) {
        let values = theme.siteWidth.values
        let containerSizes: [BreakpointValue] = [
            .init(size: .small, variable: .smallContainer, fallback: Bootstrap.smallContainer),
            .init(size: .medium, variable: .mediumContainer, fallback: Bootstrap.mediumContainer),
            .init(size: .large, variable: .largeContainer, fallback: Bootstrap.largeContainer),
            .init(size: .xLarge, variable: .xLargeContainer, fallback: Bootstrap.xLargeContainer),
            .init(size: .xxLarge, variable: .xxLargeContainer, fallback: Bootstrap.xxLargeContainer)
        ]

        for config in containerSizes {
            properties.append("    \(config.variable): \(values[config.size] ?? config.fallback)")
        }
    }

    /// Appends breakpoint CSS variables for responsive design to the properties array.
    func addBreakpointProperties(_ properties: inout [String], _ theme: any Theme) {
        let values = theme.breakpoints.values
        let breakpointSizes: [BreakpointValue] = [
            .init(size: .small, variable: .smallBreakpoint, fallback: Bootstrap.smallBreakpoint),
            .init(size: .medium, variable: .mediumBreakpoint, fallback: Bootstrap.mediumBreakpoint),
            .init(size: .large, variable: .largeBreakpoint, fallback: Bootstrap.largeBreakpoint),
            .init(size: .xLarge, variable: .xLargeBreakpoint, fallback: Bootstrap.xLargeBreakpoint),
            .init(size: .xxLarge, variable: .xxLargeBreakpoint, fallback: Bootstrap.xxLargeBreakpoint)
        ]

        for config in breakpointSizes {
            properties.append("    \(config.variable): \(values[config.size] ?? config.fallback)")
        }
    }

    /// Adds a CSS property if the value is not default
    func addProperty(_ properties: inout [String], _ variable: BootstrapVariable, _ value: any Defaultable) {
        if value.isDefault == false {
            properties.append("    \(variable.rawValue): \(value)")
        }
    }

    /// Adds color properties including RGB and theme variants
    func addColor(_ properties: inout [String], _ variable: BootstrapVariable, _ color: Color, for theme: Theme) {
        if !color.isDefault {
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
        _ color: Color, for theme: Theme
    ) {
        let bgSubtleColor = theme.colorScheme == .dark ? color.weighted(.darkest) : color.weighted(.lightest)
        var emphasisColor = theme.colorScheme == .dark ? color.weighted(.light) : color.weighted(.darker)
        var borderSubtleColor = theme.colorScheme == .dark ? color.weighted(.dark) : color.weighted(.light)

        // Special handling for dark and light roles
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

        properties.append("    \(variable.rawValue)-text-emphasis: \(emphasisColor)")
        properties.append("    \(variable.rawValue)-bg-subtle: \(bgSubtleColor)")
        properties.append("    \(variable.rawValue)-border-subtle: \(borderSubtleColor)")
    }

    /// Adds font properties with fallback to default fonts
    func addFont(_ properties: inout [String], _ variable: BootstrapVariable, _ font: Font, defaultFonts: [String]) {
        if !font.isDefault {
            properties.append("    \(variable.rawValue): \(font.name ?? defaultFonts.joined(separator: ","))")
        }
    }

    /// Adds a responsive font size for a specific breakpoint if present
    func addFontSize(
        _ properties: inout [String],
        _ variable: BootstrapVariable,
        _ sizes: ResponsiveValues<LengthUnit>,
        _ breakpoint: Breakpoint = .xSmall
    ) {
        if let size = sizes.values[breakpoint] {
            properties.append("\(variable): \(size)")
        }
    }
}
