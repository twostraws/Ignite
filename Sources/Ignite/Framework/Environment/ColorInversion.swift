//
// ColorInversion.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines user preference for inverted colors.
public enum ColorInversion: String, Environment.MediaQueryValue {
    case inverted, normal
    public var key: String { "inverted-colors" }
    public var query: String { "inverted-colors" }
}
