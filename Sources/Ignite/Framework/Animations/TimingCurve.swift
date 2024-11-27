//
// AnimationValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines the available timing functions for animations
public enum TimingCurve: CSSRepresentable {
    /// Spring animation (response: 0.55, dampingFraction: 1.0)
    case automatic
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
    /// Custom cubic-bezier curve with control points
    case bezier(x1: Double, y1: Double, x2: Double, y2: Double)

    case custom(String)

    var css: String {
        switch self {
        case .linear: "linear"
        case .easeIn: "ease-in"
        case .easeOut: "ease-out"
        case .easeInOut: "ease-in-out"
        case .spring(let damping, let velocity):
            "cubic-bezier(0.4, \(damping), \(velocity), 1.0)"
        case .bezier(let x1, let y1, let x2, let y2):
            "cubic-bezier(\(x1), \(y1), \(x2), \(y2))"
        case .automatic:
            "cubic-bezier(0.4, 1.0, 0.0, 1.0)"
        case .custom(let value):
            value
        }
    }
}

public extension TimingCurve {
    /// A smooth spring animation with minimal bounce, matching SwiftUI's default spring animation
    /// - Returns: A spring animation curve with maximum damping and no initial velocity
    static var smooth: Self {
        .spring(dampingRatio: 1.0, velocity: 0.0)
    }

    /// Creates a customizable smooth spring animation
    /// - Parameters:
    ///   - duration: The duration of the animation in seconds, defaults to SwiftUI's standard 0.55
    ///   - extraBounce: Additional bounce factor (0.0-0.3) to reduce damping, defaults to 0
    /// - Returns: A spring animation curve with customized damping based on bounce factor
    static func smooth(duration: Double = 0.55, extraBounce: Double = 0.0) -> Self {
        let dampingRatio = 1.0 - extraBounce
        return .spring(dampingRatio: dampingRatio, velocity: extraBounce)
    }

    /// A snappy spring animation with moderate bounce
    /// - Returns: A spring animation curve with reduced damping and increased velocity
    static var snappy: Self {
        .spring(dampingRatio: 0.85, velocity: 0.15)
    }

    /// Creates a customizable snappy spring animation
    /// - Parameters:
    ///   - duration: The duration of the animation in seconds, defaults to SwiftUI's standard 0.55
    ///   - extraBounce: Additional bounce factor (0.0-0.3) to reduce damping, defaults to 0
    /// - Returns: A spring animation curve with customized damping and velocity
    static func snappy(duration: Double = 0.55, extraBounce: Double = 0.0) -> Self {
        let dampingRatio = 0.85 - extraBounce
        return .spring(dampingRatio: dampingRatio, velocity: 0.15 + extraBounce)
    }

    /// A bouncy spring animation with maximum spring effect
    /// - Returns: A spring animation curve with low damping and high velocity
    static var bouncy: Self {
        .spring(dampingRatio: 0.7, velocity: 0.3)
    }

    /// Creates a customizable bouncy spring animation
    /// - Parameters:
    ///   - duration: The duration of the animation in seconds, defaults to SwiftUI's standard 0.55
    ///   - extraBounce: Additional bounce factor (0.0-0.3) to reduce damping, defaults to 0
    /// - Returns: A spring animation curve with customized damping and velocity
    static func bouncy(duration: Double = 0.55, extraBounce: Double = 0.0) -> Self {
        let dampingRatio = 0.7 - extraBounce
        return .spring(dampingRatio: dampingRatio, velocity: 0.3 + extraBounce)
    }
}
