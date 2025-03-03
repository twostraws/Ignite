//
// PublishingContext-ThemeHelpers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension PublishingContext {
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

    /// Resolves breakpoint values for a theme's responsive design settings.
    /// - Parameter theme: The theme to resolve breakpoints for.
    /// - Returns: A collection of resolved breakpoint values.
    func resolveBreakpoints(for theme: any Theme) -> ResponsiveValues {
        let breakpoints: [UnresolvedBreakpoint] = [
            .init(.small, value: theme.smallBreakpoint, default: BootstrapDefault.smallBreakpoint),
            .init(.medium, value: theme.mediumBreakpoint, default: BootstrapDefault.mediumBreakpoint),
            .init(.large, value: theme.largeBreakpoint, default: BootstrapDefault.largeBreakpoint),
            .init(.xLarge, value: theme.xLargeBreakpoint, default: BootstrapDefault.xLargeBreakpoint),
            .init(.xxLarge, value: theme.xxLargeBreakpoint, default: BootstrapDefault.xxLargeBreakpoint)
        ]

        return resolve(breakpoints)
    }

    /// Resolves container width values for a theme's responsive layout.
    /// - Parameter theme: The theme to resolve container widths for.
    /// - Returns: A collection of resolved container width values.
    func resolveSiteWidths(for theme: any Theme) -> ResponsiveValues {
        let containerSizes: [UnresolvedBreakpoint] = [
            .init(.small, value: theme.smallMaxWidth, default: BootstrapDefault.smallContainer),
            .init(.medium, value: theme.mediumMaxWidth, default: BootstrapDefault.mediumContainer),
            .init(.large, value: theme.largeMaxWidth, default: BootstrapDefault.largeContainer),
            .init(.xLarge, value: theme.xLargeMaxWidth, default: BootstrapDefault.xLargeContainer),
            .init(.xxLarge, value: theme.xxLargeMaxWidth, default: BootstrapDefault.xxLargeContainer)
        ]

        return resolve(containerSizes)
    }

    /// A breakpoint value that may inherit from previous breakpoints.
    private struct UnresolvedBreakpoint {
        /// The responsive design breakpoint this value applies to.
        var breakpoint: Breakpoint

        /// The optional value for this breakpoint, if specified.
        var value: LengthUnit

        /// The default value to use if no value is specified or inherited.
        var `default`: LengthUnit

        init(_ breakpoint: Breakpoint, value: LengthUnit, default: LengthUnit) {
            self.breakpoint = breakpoint
            self.value = value
            self.default = `default`
        }
    }

    /// Processes breakpoint values to handle value inheritance between breakpoints.
    private func resolve(_ values: [UnresolvedBreakpoint]) -> ResponsiveValues {
        let resolvedPairs = values.reduce(into: (
            results: [(Breakpoint, LengthUnit)](),
            lastValue: nil as LengthUnit?)
        ) { collected, current in
            if current.value != .default {
                collected.results.append((current.breakpoint, current.value))
                collected.lastValue = current.value
            } else if let lastValue = collected.lastValue {
                collected.results.append((current.breakpoint, lastValue))
            } else {
                collected.results.append((current.breakpoint, current.default))
            }
        }.results

        var values: [Breakpoint: LengthUnit] = [:]
        for (breakpoint, value) in resolvedPairs {
            values[breakpoint] = value
        }

        return ResponsiveValues(
            small: values[.small]!,
            medium: values[.medium]!,
            large: values[.large]!,
            xLarge: values[.xLarge]!,
            xxLarge: values[.xxLarge]!
        )
    }
}
