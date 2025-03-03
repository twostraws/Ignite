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
}
