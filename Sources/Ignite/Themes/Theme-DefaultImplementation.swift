//
// Theme-DefaultImplementation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Default implementation providing Bootstrap's default light theme values
public extension Theme {
    var accent: Color? { Color(hex: "#0d6efd") }
    var secondaryAccent: Color? { Color(hex: "#6c757d") }
    var success: Color? { Color(hex: "#198754") }
    var info: Color? { Color(hex: "#0dcaf0") }
    var warning: Color? { Color(hex: "#ffc107") }
    var danger: Color? { Color(hex: "#dc3545") }
    var light: Color? { Color(hex: "#f8f9fa") }
    var dark: Color? { Color(hex: "#212529") }
    var primary: Color? { Color(hex: "#212529") }
    var emphasis: Color? { Color(hex: "#000000") }
    var secondary: Color? { Color(red: 33, green: 37, blue: 41, opacity: 0.75) }
    var tertiary: Color? { Color(red: 33, green: 37, blue: 41, opacity: 0.5) }
    var background: Color? { Color(hex: "#ffffff") }
    var secondaryBackground: Color? { Color(hex: "#e9ecef") }
    var tertiaryBackground: Color? { Color(hex: "#f8f9fa") }
    var link: Color? { Color(hex: "#0d6efd") }
    var linkHover: Color? { Color(hex: "#0a58ca") }
    var border: Color? { Color(hex: "#dee2e6") }
    var heading: Color? { nil }

    // Font Families
    var sansSerifFont: Font? { nil }
    var monospaceFont: Font? { nil }
    var font: Font? { nil }
    var codeFont: Font? { nil }
    var alternateFonts: [Font] { [] }

    // Font Sizes
    var rootFontSize: (any LengthUnit)? { nil }
    var bodySize: (any LengthUnit)? { nil }
    var smallBodySize: (any LengthUnit)? { nil }
    var largeBodySize: (any LengthUnit)? { nil }

    // Font Weights
    var lighterFontWeight: (any LengthUnit)? { nil }
    var lightFontWeight: (any LengthUnit)? { nil }
    var regularFontWeight: (any LengthUnit)? { nil }
    var boldFontWeight: (any LengthUnit)? { nil }
    var bolderFontWeight: (any LengthUnit)? { nil }

    // Line Heights
    var regularLineHeight: (any LengthUnit)? { nil }
    var condensedLineHeight: (any LengthUnit)? { nil }
    var expandedLineHeight: (any LengthUnit)? { nil }

    // Heading Sizes
    var xxLargeHeadingSize: (any LengthUnit)? { nil }
    var xLargeHeadingSize: (any LengthUnit)? { nil }
    var largeHeadingSize: (any LengthUnit)? { nil }
    var mediumHeadingSize: (any LengthUnit)? { nil }
    var smallHeadingSize: (any LengthUnit)? { nil }
    var xSmallHeadingSize: (any LengthUnit)? { nil }

    // Heading Properties
    var headingBottomMargin: (any LengthUnit)? { nil }
    var headingFont: Font? { nil }
    var headingFontWeight: (any LengthUnit)? { nil }
    var headingLineHeight: (any LengthUnit)? { nil }

    // Breakpoints
    var xSmallBreakpoint: (any LengthUnit)? { nil }
    var smallBreakpoint: (any LengthUnit)? { nil }
    var mediumBreakpoint: (any LengthUnit)? { nil }
    var largeBreakpoint: (any LengthUnit)? { nil }
    var xLargeBreakpoint: (any LengthUnit)? { nil }
    var xxLargeBreakpoint: (any LengthUnit)? { nil }

    // Maximum widths
    var smallMaxWidth: (any LengthUnit)? { nil }
    var mediumMaxWidth: (any LengthUnit)? { nil }
    var largeMaxWidth: (any LengthUnit)? { nil }
    var xLargeMaxWidth: (any LengthUnit)? { nil }
    var xxLargeMaxWidth: (any LengthUnit)? { nil }
}
