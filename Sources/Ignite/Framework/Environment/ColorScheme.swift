//
// ColorScheme.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines user preference for light or dark color schemes.
public enum ColorScheme: String, Environment.MediaQueryValue {
    case light, dark
    public var key: String { "color-scheme" }
    public var query: String { "prefers-color-scheme" }
}
