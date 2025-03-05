//
// AutoTheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A theme that automatically switches between light and dark modes based on system preferences.
///
/// AutoTheme uses the default Bootstrap light theme values but allows JavaScript to
/// dynamically switch between light and dark modes based on the user's system preferences.
struct AutoTheme: Theme {
    var colorScheme: ColorScheme = .light
}
