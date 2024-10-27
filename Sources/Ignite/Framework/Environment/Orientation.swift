//
// Orientation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines the current device orientation.
public enum Orientation: String, Environment.MediaQueryValue {
    case landscape, portrait
    public var key: String { "orientation" }
    public var query: String { "orientation" }
}
