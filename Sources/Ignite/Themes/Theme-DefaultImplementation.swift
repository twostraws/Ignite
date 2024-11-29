//
// Theme-DefaultImplementation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

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
    var primaryBackground: Color { Color(hex: "#ffffff") }
    var secondaryBackground: Color { Color(hex: "#e9ecef") }
    var tertiaryBackground: Color { Color(hex: "#f8f9fa") }
    var link: Color { Color(hex: "#0d6efd") }
    var linkHover: Color { Color(hex: "#0a58ca") }
    var border: Color { Color(hex: "#dee2e6") }
    var heading: Color? { nil }

    // Font Families
    var sansSerifFont: Font { .systemSansSerif }
    var monospaceFont: Font { .systemMonospace }
    var font: Font { .systemBodyFont }
    var codeFont: Font { .systemCodeFont }
    var alternateFonts: [Font] { [] }

    // Font Sizes
    var rootFontSize: (any LengthUnit)? { nil } // null by default to use browser default
    var bodySize: any LengthUnit { "1rem" }
    var smallBodySize: any LengthUnit { "0.875rem" }
    var largeBodySize: any LengthUnit { "1.25rem" }

    // Font Weights
    var lighterFontWeight: any LengthUnit { 200 }
    var lightFontWeight: any LengthUnit { 300 }
    var regularFontWeight: any LengthUnit { 400 }
    var boldFontWeight: any LengthUnit { 700 }
    var bolderFontWeight: any LengthUnit { 800 }

    // Line Heights
    var regularLineHeight: any LengthUnit { 1.5 }
    var condensedLineHeight: any LengthUnit { 1.25 }
    var expandedLineHeight: any LengthUnit { 2.0 }

    // Heading Sizes
    var xxLargeHeadingSize: any LengthUnit { "2.5rem" }
    var xLargeHeadingSize: any LengthUnit { "2rem" }
    var largeHeadingSize: any LengthUnit { "1.75rem" }
    var mediumHeadingSize: any LengthUnit { "1.5rem" }
    var smallHeadingSize: any LengthUnit { "1.25rem" }
    var xSmallHeadingSize: any LengthUnit { "1rem" }

    // Heading Properties
    var headingBottomMargin: any LengthUnit { "0.5rem" }
    var headingFont: Font? { nil }
    var headingFontWeight: any LengthUnit { 500 }
    var headingLineHeight: any LengthUnit { 1.2 }

    // Breakpoints
    var xSmallBreakpoint: any LengthUnit { "0" }
    var smallBreakpoint: any LengthUnit { "576px" }
    var mediumBreakpoint: any LengthUnit { "768px" }
    var largeBreakpoint: any LengthUnit { "992px" }
    var xLargeBreakpoint: any LengthUnit { "1200px" }
    var xxLargeBreakpoint: any LengthUnit { "1400px" }

    // Maximum widths
    var smallMaxWidth: any LengthUnit { "540px" }
    var mediumMaxWidth: any LengthUnit { "720px" }
    var largeMaxWidth: any LengthUnit { "960px" }
    var xLargeMaxWidth: any LengthUnit { "1140px" }
    var xxLargeMaxWidth: any LengthUnit { "1320px" }
}
