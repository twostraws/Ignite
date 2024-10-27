//
// Contrast.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines user preference for contrast levels.
public enum Contrast: String, Environment.MediaQueryValue {
    case more, less, normal
    public var key: String { "contrast" }
    public var query: String { "prefers-contrast" }
}
