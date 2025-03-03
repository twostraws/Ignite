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
public protocol DarkTheme: Theme {}

public extension DarkTheme {
    static var colorScheme: ColorScheme { .dark }
}

extension Theme where Self == DefaultDarkTheme {
    /// Creates a default dark theme instance using Bootstrap's dark mode colors and styling
    static var dark: some Theme { DefaultDarkTheme() }
}

/// The default dark theme implementation that uses Bootstrap's dark theme values.
/// This theme provides all standard dark mode colors and styling without any customization.
struct DefaultDarkTheme: DarkTheme {
    static var name: String = "dark"

    var smallBreakpoint: LengthUnit = .default
    var mediumBreakpoint: LengthUnit = .default
    var largeBreakpoint: LengthUnit = .default
    var xLargeBreakpoint: LengthUnit = .default
    var xxLargeBreakpoint: LengthUnit = .default

    var smallMaxWidth: LengthUnit = .default
    var mediumMaxWidth: LengthUnit = .default
    var largeMaxWidth: LengthUnit = .default
    var xLargeMaxWidth: LengthUnit = .default
    var xxLargeMaxWidth: LengthUnit = .default

    init() {}

    init(breakpoints: ResponsiveValues, siteWidths: ResponsiveValues) {
        smallBreakpoint = breakpoints.small
        mediumBreakpoint = breakpoints.medium
        largeBreakpoint = breakpoints.large
        xLargeBreakpoint = breakpoints.xLarge
        xxLargeBreakpoint = breakpoints.xxLarge

        smallMaxWidth = siteWidths.small
        mediumMaxWidth = siteWidths.medium
        largeMaxWidth = siteWidths.large
        xLargeMaxWidth = siteWidths.xLarge
        xxLargeMaxWidth = siteWidths.xxLarge
    }
}
