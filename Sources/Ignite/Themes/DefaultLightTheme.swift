//
// LightTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The default light theme implementation that uses Bootstrap's light theme values.
/// This theme provides all standard light mode colors and styling without any customization.
struct DefaultLightTheme: Theme {
    typealias ResponsiveValues = Ignite.ResponsiveValues<LengthUnit>
    static var colorScheme: ColorScheme { .light }
    var siteWidth = ResponsiveValues()
    var breakpoints = ResponsiveValues()
}

extension Theme where Self == DefaultLightTheme {
    /// Creates a default light theme instance using Bootstrap's light mode colors and styling
    static var light: some Theme { DefaultLightTheme() }
}
