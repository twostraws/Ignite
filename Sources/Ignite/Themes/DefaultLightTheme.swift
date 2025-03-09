//
// LightTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension Theme where Self == DefaultLightTheme {
    /// Creates a default light theme instance using Bootstrap's light mode colors and styling
    static var light: some Theme { DefaultLightTheme() }
}

/// The default light theme implementation that uses Bootstrap's light theme values.
/// This theme provides all standard light mode colors and styling without any customization.
struct DefaultLightTheme: Theme {
    typealias ResponsiveValues = Ignite.ResponsiveValues<LengthUnit>

    var colorScheme: ColorScheme = .light
    var font: Font = .default
    var headingFont: Font = .default
    var monospaceFont: Font = .default

    var rootFontSize: LengthUnit = .default
    var inlineCodeFontSize: LengthUnit = .default
    var codeBlockFontSize: LengthUnit = .default

    var lineSpacing: LengthUnit = .default
    var headingLineSpacing: LengthUnit = .default
    var headingBottomMargin: LengthUnit = .default
    var paragraphBottomMargin: LengthUnit = .default

    var headingFontWeight: FontWeight = .default
    var linkDecoration: TextDecoration = .underline

    var bodyFontSize: ResponsiveValues = .default
    var h1Size: ResponsiveValues = .default
    var h2Size: ResponsiveValues = .default
    var h3Size: ResponsiveValues = .default
    var h4Size: ResponsiveValues = .default
    var h5Size: ResponsiveValues = .default
    var h6Size: ResponsiveValues = .default
    var siteWidth: ResponsiveValues = .default
    var breakpoints: ResponsiveValues = .default

    /// Creates a new instance by copying all non-color scheme properties from another theme
    /// - Parameter other: The theme to copy properties from
    /// - Returns: A new `DefaultLightTheme` with properties from the other theme
    func merging(_ other: any Theme) -> Self {
        var lightTheme = self

        lightTheme.font = other.font
        lightTheme.headingFont = other.headingFont
        lightTheme.monospaceFont = other.monospaceFont

        lightTheme.rootFontSize = other.rootFontSize
        lightTheme.inlineCodeFontSize = other.inlineCodeFontSize
        lightTheme.codeBlockFontSize = other.codeBlockFontSize

        lightTheme.headingFontWeight = other.headingFontWeight
        lightTheme.lineSpacing = other.lineSpacing
        lightTheme.headingLineSpacing = other.headingLineSpacing

        lightTheme.headingBottomMargin = other.headingBottomMargin
        lightTheme.paragraphBottomMargin = other.paragraphBottomMargin
        lightTheme.linkDecoration = other.linkDecoration

        lightTheme.bodyFontSize = other.bodyFontSize
        lightTheme.h1Size = other.h1Size
        lightTheme.h2Size = other.h2Size
        lightTheme.h3Size = other.h3Size
        lightTheme.h4Size = other.h4Size
        lightTheme.h5Size = other.h5Size
        lightTheme.h6Size = other.h6Size
        lightTheme.siteWidth = other.siteWidth
        lightTheme.breakpoints = other.breakpoints

        return lightTheme
    }
}
