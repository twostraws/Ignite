//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The color scheme appearance for UI elements.
@frozen public enum ColorScheme: Sendable, Hashable, Equatable, CaseIterable {
    /// The light color scheme.
    case light

    /// The dark color scheme.
    case dark

    /// The browser's color scheme.
    case automatic
}
