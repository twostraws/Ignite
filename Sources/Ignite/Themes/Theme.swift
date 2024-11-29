//
// Theme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that defines the visual styling and layout properties for a website theme.
///
/// Themes provide comprehensive control over colors, typography, spacing, and responsive
/// breakpoints. The protocol includes default implementations based on Bootstrap's default
/// theme, which can be overridden as needed.
///
/// Example:
/// ```swift
/// struct CustomTheme: Theme {
///     var id: String = "custom"
///     var primary: String = "#ff0000"
///     var fontFamilyBase: Font = .custom("Helvetica")
/// }
/// ```
public protocol Theme: Sendable {
    /// Unique identifier for the theme, automatically sanitized to lowercase with hyphens
    var id: String { get set }

    /// Primary brand color
    var accent: Color? { get }

    /// Secondary brand color
    var secondaryAccent: Color? { get }

    /// Success state color
    var success: Color? { get }

    /// Information state color
    var info: Color? { get }

    /// Warning state color
    var warning: Color? { get }

    /// Danger/error state color
    var danger: Color? { get }

    /// Light theme color
    var light: Color? { get }

    /// Dark theme color
    var dark: Color? { get }

    /// Default text color for body content
    var primary: Color? { get }

    /// Color for emphasized content
    var emphasis: Color? { get }

    /// Color for secondary content
    var secondary: Color? { get }

    /// Color for tertiary content
    var tertiary: Color? { get }

    /// Default background color
    var background: Color? { get }

    /// Secondary background color
    var secondaryBackground: Color? { get }

    /// Tertiary background color
    var tertiaryBackground: Color? { get }

    /// Default link color
    var link: Color? { get }

    /// Link color on hover
    var linkHover: Color? { get }

    /// Default border color
    var border: Color? { get }

    /// Optional custom color for headings
    var heading: Color? { get }

    /// Sans-serif font family
    var sansSerifFont: Font? { get }

    /// Monospace font family
    var monospaceFont: Font? { get }

    /// Base font family for body text
    var font: Font? { get }

    /// Font family for code blocks
    var codeFont: Font? { get }

    /// Alternate fonts
    var alternateFonts: [Font] { get }

    /// Root font size (nil uses browser default)
    var rootFontSize: (any LengthUnit)? { get }

    /// Base font size
    var bodySize: (any LengthUnit)? { get }

    /// Small font size
    var smallBodySize: (any LengthUnit)? { get }

    /// Large font size
    var largeBodySize: (any LengthUnit)? { get }

    /// Extra light font weight
    var lighterFontWeight: (any LengthUnit)? { get }

    /// Light font weight
    var lightFontWeight: (any LengthUnit)? { get }

    /// Normal font weight
    var regularFontWeight: (any LengthUnit)? { get }

    /// Bold font weight
    var boldFontWeight: (any LengthUnit)? { get }

    /// Extra bold font weight
    var bolderFontWeight: (any LengthUnit)? { get }

    /// Base line height
    var regularLineHeight: (any LengthUnit)? { get }

    /// Condensed line height
    var condensedLineHeight: (any LengthUnit)? { get }

    /// Expanded line height
    var expandedLineHeight: (any LengthUnit)? { get }

    /// Font size for h1 elements
    var xxLargeHeadingSize: (any LengthUnit)? { get }

    /// Font size for h2 elements
    var xLargeHeadingSize: (any LengthUnit)? { get }

    /// Font size for h3 elements
    var largeHeadingSize: (any LengthUnit)? { get }

    /// Font size for h4 elements
    var mediumHeadingSize: (any LengthUnit)? { get }

    /// Font size for h5 elements
    var smallHeadingSize: (any LengthUnit)? { get }

    /// Font size for h6 elements
    var xSmallHeadingSize: (any LengthUnit)? { get }

    /// Bottom margin for headings
    var headingBottomMargin: (any LengthUnit)? { get }

    /// Optional custom font family for headings
    var headingFont: Font? { get }

    /// Font weight for headings
    var headingFontWeight: (any LengthUnit)? { get }

    /// Line height for headings
    var headingLineHeight: (any LengthUnit)? { get }

    /// Extra small breakpoint
    var xSmallBreakpoint: (any LengthUnit)? { get }

    /// Small breakpoint
    var smallBreakpoint: (any LengthUnit)? { get }

    /// Medium breakpoint
    var mediumBreakpoint: (any LengthUnit)? { get }

    /// Large breakpoint
    var largeBreakpoint: (any LengthUnit)? { get }

    /// Extra large breakpoint
    var xLargeBreakpoint: (any LengthUnit)? { get }

    /// Extra extra large breakpoint
    var xxLargeBreakpoint: (any LengthUnit)? { get }

    /// Maximum width for small containers
    var smallMaxWidth: (any LengthUnit)? { get }

    /// Maximum width for medium containers
    var mediumMaxWidth: (any LengthUnit)? { get }

    /// Maximum width for large containers
    var largeMaxWidth: (any LengthUnit)? { get }

    /// Maximum width for extra large containers
    var xLargeMaxWidth: (any LengthUnit)? { get }

    /// Maximum width for extra extra large containers
    var xxLargeMaxWidth: (any LengthUnit)? { get }
}
