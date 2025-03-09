//
// DarkTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Theme where Self == DefaultDarkTheme {
    /// Creates a default dark theme instance using Bootstrap's dark mode colors and styling
    static var dark: some Theme { DefaultDarkTheme() }
}

/// The default dark theme implementation that uses Bootstrap's dark theme values.
/// This theme provides all standard dark mode colors and styling without any customization.
struct DefaultDarkTheme: Theme {
    typealias ResponsiveValues = Ignite.ResponsiveValues<LengthUnit>

    var colorScheme: ColorScheme = .dark
    var font: Font = .default
    var headingFont: Font = .default
    var monospaceFont: Font = .default

    var rootFontSize: LengthUnit = .default
    var inlineCodeFontSize: LengthUnit = .default
    var codeBlockFontSize: LengthUnit = .default

    var headingFontWeight: FontWeight = .default
    var lineSpacing: LengthUnit = .default
    var headingLineSpacing: LengthUnit = .default

    var headingBottomMargin: LengthUnit = .default
    var paragraphBottomMargin: LengthUnit = .default

    var linkDecoration: TextDecoration = .underline

    var bodyFontSize = ResponsiveValues.default
    var h1Size = ResponsiveValues.default
    var h2Size = ResponsiveValues.default
    var h3Size = ResponsiveValues.default
    var h4Size = ResponsiveValues.default
    var h5Size = ResponsiveValues.default
    var h6Size = ResponsiveValues.default
    var siteWidth = ResponsiveValues.default
    var breakpoints = ResponsiveValues.default

    /// Creates a new instance by copying all non-color scheme properties from another theme
    /// - Parameter other: The theme to copy properties from
    /// - Returns: A new `DefaultDarkTheme` with properties from the other theme
    func merging(_ other: any Theme) -> Self {
        var darkTheme = self

        darkTheme.font = other.font
        darkTheme.headingFont = other.headingFont
        darkTheme.monospaceFont = other.monospaceFont

        darkTheme.rootFontSize = other.rootFontSize
        darkTheme.inlineCodeFontSize = other.inlineCodeFontSize
        darkTheme.codeBlockFontSize = other.codeBlockFontSize

        darkTheme.lineSpacing = other.lineSpacing
        darkTheme.headingLineSpacing = other.headingLineSpacing
        darkTheme.headingBottomMargin = other.headingBottomMargin
        darkTheme.paragraphBottomMargin = other.paragraphBottomMargin

        darkTheme.headingFontWeight = other.headingFontWeight
        darkTheme.linkDecoration = other.linkDecoration

        darkTheme.bodyFontSize = other.bodyFontSize
        darkTheme.h1Size = other.h1Size
        darkTheme.h2Size = other.h2Size
        darkTheme.h3Size = other.h3Size
        darkTheme.h4Size = other.h4Size
        darkTheme.h5Size = other.h5Size
        darkTheme.h6Size = other.h6Size
        darkTheme.siteWidth = other.siteWidth
        darkTheme.breakpoints = other.breakpoints

        return darkTheme
    }
}
