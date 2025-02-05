//
// Theme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the visual styling and layout properties for a website theme.
///
/// Themes provide comprehensive control over colors, typography, spacing, and responsive
/// breakpoints. The protocol includes default implementations based on Bootstrap's default
/// theme, which can be overridden as needed.
///
/// Example:
/// ```swift
/// struct CustomTheme: Theme {
///     static var name: String = "custom"
///     var primary: String = "#ff0000"
///     var fontFamilyBase: Font = .custom("Helvetica")
/// }
/// ```
@MainActor
public protocol Theme: Sendable {
    /// The name of the theme, which must be unique
    static var name: String { get set }

    /// Primary brand color
    var accent: Color { get }

    /// Secondary brand color
    var secondaryAccent: Color { get }

    /// Success state color
    var success: Color { get }

    /// Information state color
    var info: Color { get }

    /// Warning state color
    var warning: Color { get }

    /// Danger/error state color
    var danger: Color { get }

    /// Light theme color
    var light: Color { get }

    /// Dark theme color
    var dark: Color { get }

    /// Default text color for body content
    var primary: Color { get }

    /// Color for emphasized content
    var emphasis: Color { get }

    /// Color for secondary content
    var secondary: Color { get }

    /// Color for tertiary content
    var tertiary: Color { get }

    /// Default background color
    var background: Color { get }

    /// Secondary background color
    var secondaryBackground: Color { get }

    /// Tertiary background color
    var tertiaryBackground: Color { get }

    /// Default link color
    var link: Color { get }

    /// Link color on hover
    var linkHover: Color { get }

    /// Link text decoration style
    var linkDecoration: TextDecoration { get }

    /// Default border color
    var border: Color { get }

    /// Optional custom color for headings
    var heading: Color { get }

    /// Sans-serif font family
    var sansSerifFont: Font { get }

    /// Monospace font family
    var monospaceFont: Font { get }

    /// Base font family for body text
    var font: Font { get }

    /// Font family for code blocks
    var codeFont: Font { get }

    /// Alternate fonts
    var alternateFonts: [Font] { get }

    /// Root font size nil uses browser default
    var rootFontSize: LengthUnit { get }

    /// Base font size
    var bodySize: LengthUnit { get }

    /// Small font size
    var smallBodySize: LengthUnit { get }

    /// Large font size
    var largeBodySize: LengthUnit { get }

    /// Extra light font weight
    var lighterFontWeight: LengthUnit { get }

    /// Light font weight
    var lightFontWeight: LengthUnit { get }

    /// Normal font weight
    var regularFontWeight: LengthUnit { get }

    /// Bold font weight
    var boldFontWeight: LengthUnit { get }

    /// Extra bold font weight
    var bolderFontWeight: LengthUnit { get }

    /// Base line height
    var regularLineHeight: LengthUnit { get }

    /// Condensed line height
    var condensedLineHeight: LengthUnit { get }

    /// Expanded line height
    var expandedLineHeight: LengthUnit { get }

    /// Font size for h1 elements
    var xxLargeHeadingSize: LengthUnit { get }

    /// Font size for h2 elements
    var xLargeHeadingSize: LengthUnit { get }

    /// Font size for h3 elements
    var largeHeadingSize: LengthUnit { get }

    /// Font size for h4 elements
    var mediumHeadingSize: LengthUnit { get }

    /// Font size for h5 elements
    var smallHeadingSize: LengthUnit { get }

    /// Font size for h6 elements
    var xSmallHeadingSize: LengthUnit { get }

    /// Optional custom font family for headings
    var headingFont: Font { get }

    /// Font weight for headings
    var headingFontWeight: LengthUnit { get }

    /// Line height for headings
    var headingLineHeight: LengthUnit { get }

    /// Bottom margin for headings
    var headingBottomMargin: LengthUnit { get }

    /// Bottom margin for paragraphs
    var paragraphBottomMargin: LengthUnit { get }

    /// Extra small breakpoint
    var xSmallBreakpoint: LengthUnit { get }

    /// Small breakpoint
    var smallBreakpoint: LengthUnit { get }

    /// Medium breakpoint
    var mediumBreakpoint: LengthUnit { get }

    /// Large breakpoint
    var largeBreakpoint: LengthUnit { get }

    /// Extra large breakpoint
    var xLargeBreakpoint: LengthUnit { get }

    /// Extra extra large breakpoint
    var xxLargeBreakpoint: LengthUnit { get }

    /// Maximum width for small containers
    var smallMaxWidth: LengthUnit { get }

    /// Maximum width for medium containers
    var mediumMaxWidth: LengthUnit { get }

    /// Maximum width for large containers
    var largeMaxWidth: LengthUnit { get }

    /// Maximum width for extra large containers
    var xLargeMaxWidth: LengthUnit { get }

    /// Maximum width for extra extra large containers
    var xxLargeMaxWidth: LengthUnit { get }

    /// The color scheme for syntax highlighting
    var syntaxHighlighterTheme: HighlighterTheme { get }
}
