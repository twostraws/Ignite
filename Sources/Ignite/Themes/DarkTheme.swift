//
// DarkTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that provides Bootstrap's dark theme defaults as a starting point for custom themes.
/// Conforming types automatically inherit all default dark theme values and can override specific properties as needed.
///
/// Example:
/// ```swift
/// struct CustomDarkTheme: DarkTheme {
///     var id: String = "custom-dark"
///     var primary: String = "#990000" // Override just the primary color
/// }
/// ```
public protocol DarkTheme: Theme
where
    CodeConfiguration == CodeDarkConfiguration,
    ColorPaletteConfiguration == ColorPaletteDarkConfiguration,
    HeadingConfiguration == HeadingDarkConfiguration,
    LinkConfiguration == LinkDarkConfiguration,
    TextConfiguration == TextDarkConfiguration
{ }

public extension DarkTheme {
    var colorPalette: ColorPaletteConfiguration { .init() }
    var text: TextConfiguration { .init() }
    var code: CodeConfiguration { .init() }
    var headings: HeadingConfiguration { .init() }
    var links: LinkConfiguration { .init() }
    var siteWidths: SiteWidthConfiguration { .init() }
    var breakpoints: BreakpointConfiguration { .init() }
}

extension Theme where Self == DefaultDarkTheme {
    /// Creates a default dark theme instance using Bootstrap's dark mode colors and styling
    static var dark: some Theme { DefaultDarkTheme() }
}

/// The default dark theme implementation that uses Bootstrap's dark theme values.
/// This theme provides all standard dark mode colors and styling without any customization.
struct DefaultDarkTheme: DarkTheme {
    static var name: String = "dark"
    var breakpoints: BreakpointConfiguration = .init()
    var siteWidths: SiteWidthConfiguration = .init()
}
