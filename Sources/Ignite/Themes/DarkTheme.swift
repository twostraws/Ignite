//
// DarkTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

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
    var accent: Color? { Color(hex: "#0d6efd") }
    var secondaryAccent: Color? { Color(hex: "#6c757d") }
    var success: Color? { Color(hex: "#198754") }
    var info: Color? { Color(hex: "#0dcaf0") }
    var warning: Color? { Color(hex: "#ffc107") }
    var danger: Color? { Color(hex: "#dc3545") }
    var light: Color? { Color(hex: "#f8f9fa") }
    var dark: Color? { Color(hex: "#212529") }
    var primary: Color? { Color(hex: "#dee2e6") }
    var background: Color? { Color(hex: "#212529") }
    var emphasis: Color? { Color(hex: "#ffffff") }
    var secondary: Color? { Color(red: 222, green: 226, blue: 230, opacity: 0.75) }
    var tertiary: Color? { Color(red: 222, green: 226, blue: 230, opacity: 0.5) }
    var secondaryBackground: Color? { Color(hex: "#343a40") }
    var tertiaryBackground: Color? { Color(hex: "#2b3035") }
    var link: Color? { Color(hex: "#6ea8fe") }
    var linkHover: Color? { Color(hex: "#8bb9fe") }
    var border: Color? { Color(hex: "#495057") }
}

extension Theme where Self == DefaultDarkTheme {
    /// Creates a default dark theme instance using Bootstrap's dark mode colors and styling
    static var dark: some Theme { DefaultDarkTheme() }
}

/// The default dark theme implementation that uses Bootstrap's dark theme values.
/// This theme provides all standard dark mode colors and styling without any customization.
struct DefaultDarkTheme: DarkTheme {
    var id: String = "dark"
}
