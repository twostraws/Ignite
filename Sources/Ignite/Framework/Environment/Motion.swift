//
// Motion.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines user preference for reduced motion.
public enum Motion: String, Environment.MediaQueryValue {
    case reduced, normal
    public var key: String { "motion" }
    public var query: String { "prefers-reduced-motion" }
}
