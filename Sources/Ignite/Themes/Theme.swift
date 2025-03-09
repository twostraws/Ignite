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
public protocol Theme: Sendable {
    /// The appearance mode this theme represents
    var colorScheme: ColorScheme { get }

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
    var offWhite: Color { get }

    /// Dark theme color
    var offBlack: Color { get }

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
    var hoveredLink: Color { get }

    /// Link text decoration style
    var linkDecoration: TextDecoration { get }

    /// Default border color
    var border: Color { get }

    /// Monospace font family
    var monospaceFont: Font { get }

    /// Base font family for body text
    var font: Font { get }

    /// Root font size nil uses browser default
    var rootFontSize: LengthUnit { get }

    /// Inline code font size
    var inlineCodeFontSize: LengthUnit { get }

    /// Code block font size
    var codeBlockFontSize: LengthUnit { get }

    /// Base line height
    var lineSpacing: LengthUnit { get }

    /// Custom font family for headings
    var headingFont: Font { get }

    /// Font weight for headings
    var headingFontWeight: FontWeight { get }

    /// Line height for headings
    var headingLineSpacing: LengthUnit { get }

    /// Bottom margin for headings
    var headingBottomMargin: LengthUnit { get }

    /// Bottom margin for paragraphs
    var paragraphBottomMargin: LengthUnit { get }

    /// The color scheme for syntax highlighting
    var syntaxHighlighterTheme: HighlighterTheme { get }

    typealias ResponsiveValues = Ignite.ResponsiveValues<LengthUnit>

    /// Base font size
    var bodyFontSize: ResponsiveValues { get }

    /// Font size for h1 elements
    var h1Size: ResponsiveValues { get }

    /// Font size for h2 elements
    var h2Size: ResponsiveValues { get }

    /// Font size for h3 elements
    var h3Size: ResponsiveValues { get }

    /// Font size for h4 elements
    var h4Size: ResponsiveValues { get }

    /// Font size for h5 elements
    var h5Size: ResponsiveValues { get }

    /// Font size for h6 elements
    var h6Size: ResponsiveValues { get }

    /// The maximum width of the site's content at different breakpoints.
    var siteWidth: ResponsiveValues { get }

    /// The values that define the site's responsive breakpoints.
    var breakpoints: ResponsiveValues { get }
}
