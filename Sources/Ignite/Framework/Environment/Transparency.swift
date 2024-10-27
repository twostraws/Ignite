//
// Transparency.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines user preference for reduced transparency.
public enum Transparency: String, Environment.MediaQueryValue {
    case reduced, normal
    public var key: String { "transparency" }
    public var query: String { "prefers-reduced-transparency" }
}
