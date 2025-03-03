//
// Theme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines a website theme through a collection of configurations.
///
/// Themes are organized into logical configuration groups:
/// - `colorPalette`: The complete color system
/// - `typography`: Core font settings and weights
/// - `text` and `headings`: Element-specific typography
/// - `links` and `code`: Special element formatting
/// - `siteWidths` and `breakpoints`: Layout and responsive design
///
/// Each configuration provides default values that can be selectively overridden:
///
/// ```swift
/// struct CustomTheme: Theme {
///     static var name: String = "custom"
///
///     var colorPalette = ColorPaletteConfiguration(
///         accent: .hex("#0d6efd"),
///         primary: .hex("#212529")
///     )
///
///     var typography = TypographyConfiguration(
///         rootSize: .px(16),
///         weights: .init(bold: .w700)
///     )
///
///     var text = TextConfiguration(
///         font: .custom("Georgia"),
///         lineHeight: .rem(1.6)
///     )
/// }
/// ```
/// A protocol that defines a complete theme for a website, including all visual styling and layout rules.
@MainActor
public protocol Theme: Sendable {
    /// The configuration type for link styling
    associatedtype LinkConfiguration: LinkThemeConfiguration

    /// The configuration type for heading styling
    associatedtype HeadingConfiguration: HeadingThemeConfiguration

    /// The configuration type for code block styling
    associatedtype CodeConfiguration: CodeThemeConfiguration

    /// The configuration type for the theme's color system
    associatedtype ColorPaletteConfiguration: ColorPaletteThemeConfiguration

    /// The configuration type for text styling
    associatedtype TextConfiguration: TextThemeConfiguration

    /// The unique identifier for this theme
    static var name: String { get set }

    /// The base font size from which relative font sizes are calculated (defaults to 16px)
    var rootFontSize: LengthUnit? { get }

    /// The complete color system including brand, semantic, text, and background colors
    var colorPalette: ColorPaletteConfiguration { get }

    /// Configuration for general text styling including sizes and spacing
    var text: TextConfiguration { get }

    /// Configuration for code formatting in both inline and block contexts
    var code: CodeConfiguration { get }

    /// Configuration for link appearance and interaction states
    var links: LinkConfiguration { get }

    /// Configuration for heading styles across all six heading levels
    var headings: HeadingConfiguration { get }

    /// Configuration for maximum content widths at each breakpoint
    var siteWidths: SiteWidthConfiguration { get }

    /// Configuration for responsive design breakpoint dimensions
    var breakpoints: BreakpointConfiguration { get }
}
