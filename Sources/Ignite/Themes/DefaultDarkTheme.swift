//
// DarkTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The default dark theme implementation that uses Bootstrap's dark theme values.
/// This theme provides all standard dark mode colors and styling without any customization.
struct DefaultDarkTheme: Theme {
    typealias ResponsiveValues = Ignite.ResponsiveValues<LengthUnit>
    static var name: String = "dark"
    static var colorScheme: ColorScheme { .dark }
    var siteWidth = ResponsiveValues()
    var breakpoints = ResponsiveValues()
}

extension Theme where Self == DefaultDarkTheme {
    /// Creates a default dark theme instance using Bootstrap's dark mode colors and styling
    static var dark: some Theme { DefaultDarkTheme() }
}
