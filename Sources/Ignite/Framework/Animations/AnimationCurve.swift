//
// AnimationValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines the available timing functions for animations
public enum AnimationCurve {
    /// Linear timing with constant speed
    case linear
    /// Starts slow, then speeds up
    case easeIn
    /// Starts fast, then slows down
    case easeOut
    /// Starts slow, speeds up in the middle, then slows down
    case easeInOut
    /// Spring-like animation with customizable damping and velocity
    case spring(dampingRatio: Double, velocity: Double)
    
    case custom(String)
    
    var cssValue: String {
        switch self {
        case .linear: return "linear"
        case .easeIn: return "ease-in"
        case .easeOut: return "ease-out"
        case .easeInOut: return "ease-in-out"
        case .spring(let damping, let velocity):
            return "cubic-bezier(0.4, \(damping), \(velocity), 1.0)"
        case .custom(let value):
            return value
        }
    }
}
