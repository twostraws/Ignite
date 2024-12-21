//
// Theme-DefaultImplementation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Default implementation providing Bootstrap's default light theme values
public extension Theme {
    var accent: Color { Color(hex: "#0d6efd") }
    var secondaryAccent: Color { Color(hex: "#6c757d") }
    var success: Color { Color(hex: "#198754") }
    var info: Color { Color(hex: "#0dcaf0") }
    var warning: Color { Color(hex: "#ffc107") }
    var danger: Color { Color(hex: "#dc3545") }
    var light: Color { Color(hex: "#f8f9fa") }
    var dark: Color { Color(hex: "#212529") }
    var primary: Color { Color(hex: "#212529") }
    var emphasis: Color { Color(hex: "#000000") }
    var secondary: Color { Color(red: 33, green: 37, blue: 41, opacity: 0.75) }
    var tertiary: Color { Color(red: 33, green: 37, blue: 41, opacity: 0.5) }
    var background: Color { Color(hex: "#ffffff") }
    var secondaryBackground: Color { Color(hex: "#e9ecef") }
    var tertiaryBackground: Color { Color(hex: "#f8f9fa") }
    var link: Color { Color(hex: "#0d6efd") }
    var linkHover: Color { Color(hex: "#0a58ca") }
    var border: Color { Color(hex: "#dee2e6") }
    var heading: Color { .default }
    var syntaxHighlighterTheme: HighlighterTheme { .automatic }

    // Font Families
    var sansSerifFont: Font { .default }
    var monospaceFont: Font { .default }
    var font: Font { .default }
    var codeFont: Font { .default }
    var alternateFonts: [Font] { [] }

    // Font Sizes
    var rootFontSize: any LengthUnit { .default }
    var bodySize: any LengthUnit { .default }
    var smallBodySize: any LengthUnit { .default }
    var largeBodySize: any LengthUnit { .default }

    // Font Weights
    var lighterFontWeight: any LengthUnit { .default }
    var lightFontWeight: any LengthUnit { .default }
    var regularFontWeight: any LengthUnit { .default }
    var boldFontWeight: any LengthUnit { .default }
    var bolderFontWeight: any LengthUnit { .default }

    // Line Heights
    var regularLineHeight: any LengthUnit { .default }
    var condensedLineHeight: any LengthUnit { .default }
    var expandedLineHeight: any LengthUnit { .default }

    // Heading Sizes
    var xxLargeHeadingSize: any LengthUnit { .default }
    var xLargeHeadingSize: any LengthUnit { .default }
    var largeHeadingSize: any LengthUnit { .default }
    var mediumHeadingSize: any LengthUnit { .default }
    var smallHeadingSize: any LengthUnit { .default }
    var xSmallHeadingSize: any LengthUnit { .default }

    // Heading Properties
    var headingBottomMargin: any LengthUnit { .default }
    var headingFont: Font { .default }
    var headingFontWeight: any LengthUnit { .default }
    var headingLineHeight: any LengthUnit { .default }

    // Breakpoints
    var xSmallBreakpoint: any LengthUnit { .default }
    var smallBreakpoint: any LengthUnit { .default }
    var mediumBreakpoint: any LengthUnit { .default }
    var largeBreakpoint: any LengthUnit { .default }
    var xLargeBreakpoint: any LengthUnit { .default }
    var xxLargeBreakpoint: any LengthUnit { .default }

    // Maximum widths
    var smallMaxWidth: any LengthUnit { .default }
    var mediumMaxWidth: any LengthUnit { .default }
    var largeMaxWidth: any LengthUnit { .default }
    var xLargeMaxWidth: any LengthUnit { .default }
    var xxLargeMaxWidth: any LengthUnit { .default }
}

extension Theme {
    /// Internal identifier used for theme switching and CSS selectors.
    /// Automatically appends "-light" or "-dark" suffix based on protocol conformance.
    var id: String {
        let baseID = name.kebabCased()

        guard type(of: self) != DefaultLightTheme.self && type(of: self) != DefaultDarkTheme.self else {
            return baseID
        }

        switch self {
        case is LightTheme: return baseID + "-light"
        case is DarkTheme: return baseID + "-dark"
        default: return baseID
        }
    }
}
