//
// BootstrapVariable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of CSS variables used by Bootstrap for theming.
///
/// Bootstrap variables control various aspects of a theme including colors, typography,
/// and spacing. Each case represents a specific CSS variable that
/// Bootstrap uses for consistent styling across components.
enum BootstrapVariable: String {
    // MARK: - Brand Colors

    /// The primary brand color
    case primary = "--bs-primary"

    /// The secondary brand color
    case secondary = "--bs-secondary"

    /// Color used for success states
    case success = "--bs-success"

    /// Color used for informational states
    case info = "--bs-info"

    /// Color used for warning states
    case warning = "--bs-warning"

    /// Color used for danger or error states
    case danger = "--bs-danger"

    /// Color used for light theme elements
    case light = "--bs-light"

    /// Color used for dark theme elements
    case dark = "--bs-dark"

    // MARK: - Body Settings

    /// Default text color for body content
    case bodyColor = "--bs-body-color"

    /// Default background color for the body
    case bodyBackground = "--bs-body-bg"

    // MARK: - Emphasis Colors

    /// Color for emphasized content
    case emphasisColor = "--bs-emphasis-color"

    /// Color for secondary content
    case secondaryColor = "--bs-secondary-color"

    /// Color for tertiary content
    case tertiaryColor = "--bs-tertiary-color"

    // MARK: - Background Colors

    /// Secondary background color
    case secondaryBackground = "--bs-secondary-bg"

    /// Tertiary background color
    case tertiaryBackground = "--bs-tertiary-bg"

    // MARK: - Link Colors

    /// Default color for links
    case linkColor = "--bs-link-color"

    /// Color for links on hover
    case linkHoverColor = "--bs-link-hover-color"

    // MARK: - Border Colors

    /// Default border color
    case borderColor = "--bs-border-color"

    // MARK: - Font Families

    /// Sans-serif font family
    case sansSerifFont = "--bs-font-sans-serif"

    /// Monospace font family
    case monospaceFont = "--bs-font-monospace"

    /// Base body font family
    case bodyFont = "--bs-body-font-family"

    /// Font family for code blocks
    case codeFont = "--bs-font-code"

    // MARK: - Font Sizes

    /// Root element font size
    case rootFontSize = "--bs-root-font-size"

    /// Base body font size
    case bodyFontSize = "--bs-body-font-size"

    /// Small body font size
    case smallBodyFontSize = "--bs-body-font-size-sm"

    /// Large body font size
    case largeBodyFontSize = "--bs-body-font-size-lg"

    // MARK: - Heading Sizes

    /// Font size for h1 elements
    case h1FontSize = "--bs-h1-font-size"

    /// Font size for h2 elements
    case h2FontSize = "--bs-h2-font-size"

    /// Font size for h3 elements
    case h3FontSize = "--bs-h3-font-size"

    /// Font size for h4 elements
    case h4FontSize = "--bs-h4-font-size"

    /// Font size for h5 elements
    case h5FontSize = "--bs-h5-font-size"

    /// Font size for h6 elements
    case h6FontSize = "--bs-h6-font-size"

    // MARK: - Font Weights

    /// Extra light font weight
    case lighterFontWeight = "--bs-font-weight-lighter"

    /// Light font weight
    case lightFontWeight = "--bs-font-weight-light"

    /// Normal font weight
    case normalFontWeight = "--bs-font-weight-normal"

    /// Bold font weight
    case boldFontWeight = "--bs-font-weight-bold"

    /// Extra bold font weight
    case bolderFontWeight = "--bs-font-weight-bolder"

    // MARK: - Line Heights

    /// Default body line height
    case bodyLineHeight = "--bs-body-line-height"

    /// Condensed line height
    case condensedLineHeight = "--bs-line-height-sm"

    /// Expanded line height
    case expandedLineHeight = "--bs-line-height-lg"

    // MARK: - Heading Properties

    /// Bottom margin for headings
    case headingsMarginBottom = "--bs-headings-margin-bottom"

    /// Font weight for headings
    case headingsFontWeight = "--bs-headings-font-weight"

    /// Line height for headings
    case headingsLineHeight = "--bs-headings-line-height"

    // MARK: - Container Sizes

    /// Maximum width for small containers
    case containerSm = "--theme-container-sm"

    /// Maximum width for medium containers
    case containerMd = "--theme-container-md"

    /// Maximum width for large containers
    case containerLg = "--theme-container-lg"

    /// Maximum width for extra large containers
    case containerXl = "--theme-container-xl"

    /// Maximum width for extra extra large containers
    case containerXxl = "--theme-container-xxl"
}
