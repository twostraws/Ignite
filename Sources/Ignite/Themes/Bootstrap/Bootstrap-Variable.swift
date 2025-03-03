//
// BootstrapVariable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

typealias BootstrapVariable = Bootstrap.Variable

extension Bootstrap {
    /// A collection of CSS variables used by Bootstrap for theming.
    ///
    /// Bootstrap variables control various aspects of a theme including colors, typography,
    /// and spacing. Each case represents a specific CSS variable that
    /// Bootstrap uses for consistent styling across components.
    enum Variable: String {
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

        /// Link text decoration
        case linkDecoration = "--bs-link-decoration"

        // MARK: - Border Colors

        /// Default border color
        case borderColor = "--bs-border-color"

        // MARK: - Font Families

        /// Monospace font family
        case monospaceFont = "--bs-font-monospace"

        /// Base body font family
        case bodyFont = "--bs-body-font-family"

        /// Font family for headings
        case headingFont = "--bs-headings-font-family"

        // MARK: - Font Sizes

        /// Root element font size
        case rootFontSize = "--bs-root-font-size"

        /// Inline code font size
        case inlineCodeFontSize = "--bs-code-font-size"

        /// Code block font size
        case codeBlockFontSize = "--code-block-font-size"

        // MARK: - Body Sizes

        /// Base body font size
        case bodyFontSize = "--bs-body-font-size"

        /// Body font size for small screens (≥576px)
        case smallBodyFontSize = "--ig-body-font-size-sm"

        /// Body font size for medium screens (≥768px)
        case mediumBodyFontSize = "--ig-body-font-size-md"

        /// Body font size for large screens (≥992px)
        case largeBodyFontSize = "--ig-body-font-size-lg"

        /// Body font size for extra large screens (≥1200px)
        case xLargeBodyFontSize = "--ig-body-font-size-xl"

        /// Body font size for extra extra large screens (≥1400px)
        case xxLargeBodyFontSize = "--ig-body-font-size-xxl"

        // MARK: - Heading Sizes

        /// Font size for h1 elements
        case h1FontSize = "--bs-h1-font-size"

        case smallH1FontSize = "--ig-h1-font-size-sm"
        case mediumH1FontSize = "--ig-h1-font-size-md"
        case largeH1FontSize = "--ig-h1-font-size-lg"
        case xLargeH1FontSize = "--ig-h1-font-size-xl"
        case xxLargeH1FontSize = "--ig-h1-font-size-xxl"

        /// Font size for h2 elements
        case h2FontSize = "--bs-h2-font-size"

        case smallH2FontSize = "--ig-h2-font-size-sm"
        case mediumH2FontSize = "--ig-h2-font-size-md"
        case largeH2FontSize = "--ig-h2-font-size-lg"
        case xLargeH2FontSize = "--ig-h2-font-size-xl"
        case xxLargeH2FontSize = "--ig-h2-font-size-xxl"

        /// Font size for h3 elements
        case h3FontSize = "--bs-h3-font-size"

        case smallH3FontSize = "--ig-h3-font-size-sm"
        case mediumH3FontSize = "--ig-h3-font-size-md"
        case largeH3FontSize = "--ig-h3-font-size-lg"
        case xLargeH3FontSize = "--ig-h3-font-size-xl"
        case xxLargeH3FontSize = "--ig-h3-font-size-xxl"

        /// Font size for h4 elements
        case h4FontSize = "--bs-h4-font-size"

        case smallH4FontSize = "--ig-h4-font-size-sm"
        case mediumH4FontSize = "--ig-h4-font-size-md"
        case largeH4FontSize = "--ig-h4-font-size-lg"
        case xLargeH4FontSize = "--ig-h4-font-size-xl"
        case xxLargeH4FontSize = "--ig-h4-font-size-xxl"

        /// Font size for h5 elements
        case h5FontSize = "--bs-h5-font-size"

        case smallH5FontSize = "--ig-h5-font-size-sm"
        case mediumH5FontSize = "--ig-h5-font-size-md"
        case largeH5FontSize = "--ig-h5-font-size-lg"
        case xLargeH5FontSize = "--ig-h5-font-size-xl"
        case xxLargeH5FontSize = "--ig-h5-font-size-xxl"

        /// Font size for h6 elements
        case h6FontSize = "--bs-h6-font-size"

        case smallH6FontSize = "--ig-h6-font-size-sm"
        case mediumH6FontSize = "--ig-h6-font-size-md"
        case largeH6FontSize = "--ig-h6-font-size-lg"
        case xLargeH6FontSize = "--ig-h6-font-size-xl"
        case xxLargeH6FontSize = "--ig-h6-font-size-xxl"

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

        /// Font weight for headings
        case headingsFontWeight = "--bs-headings-font-weight"

        /// Line height for headings
        case headingsLineHeight = "--bs-headings-line-height"

        // MARK: - Bottom Margins

        /// Bottom margin for headings
        case headingsMarginBottom = "--bs-headings-margin-bottom"

        /// Paragraph margin bottom
        case paragraphMarginBottom = "--bs-paragraph-margin-bottom"

        // MARK: - Container Sizes

        /// Maximum width for small containers
        case xSmallContainer = "--theme-container-xs"

        /// Maximum width for small containers
        case smallContainer = "--theme-container-sm"

        /// Maximum width for medium containers
        case mediumContainer = "--theme-container-md"

        /// Maximum width for large containers
        case largeContainer = "--theme-container-lg"

        /// Maximum width for extra large containers
        case xLargeContainer = "--theme-container-xl"

        /// Maximum width for extra extra large containers
        case xxLargeContainer = "--theme-container-xxl"

        // MARK: - Breakpoints

        /// Small breakpoint value
        case xSmallBreakpoint = "--bs-breakpoint-xs"

        /// Small breakpoint value
        case smallBreakpoint = "--bs-breakpoint-sm"

        /// Medium breakpoint value
        case mediumBreakpoint = "--bs-breakpoint-md"

        /// Large breakpoint value
        case largeBreakpoint = "--bs-breakpoint-lg"

        /// Extra large breakpoint value
        case xLargeBreakpoint = "--bs-breakpoint-xl"

        /// Extra extra large breakpoint value
        case xxLargeBreakpoint = "--bs-breakpoint-xxl"

        /// Whether this variable has dependent colors.
        var isThemeColor: Bool {
            switch self {
            case .primary, .secondary, .success, .info, .warning, .danger, .light, .dark:
                return true
            default:
                return false
            }
        }
    }
}

extension BootstrapVariable: CustomStringConvertible {
    var description: String {
        rawValue
    }
}
