//
// LightTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A protocol that provides Bootstrap's light theme defaults as a starting point for custom themes.
/// Conforming types automatically inherit all default light theme values and can override specific properties as needed.
///
/// Example:
/// ```swift
/// struct CustomLightTheme: LightTheme {
///     var id: String = "custom-light"
///     var primary: String = "#ff0000" // Override just the primary color
/// }
/// ```
public protocol LightTheme: Theme {}

extension Theme where Self == DefaultLightTheme {
    /// Creates a default light theme instance using Bootstrap's light mode colors and styling
    static var light: some Theme { DefaultLightTheme() }
}

/// The default light theme implementation that uses Bootstrap's light theme values.
/// This theme provides all standard light mode colors and styling without any customization.
struct DefaultLightTheme: LightTheme {
    var id: String = "light"
}
