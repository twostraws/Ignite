//
// StandardAnimation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A basic animation type that transitions a single CSS property from one value to another.
public struct AnimatableData {
    /// The starting value for the animated property
    var initial: String

    /// The ending value for the animated property
    var final: String

    /// The CSS property to animate (e.g., "opacity", "transform", "background-color")
    var property: AnimatableProperty

    /// The duration of the animation in seconds.
    var duration: Double = 0.35

    /// The timing function that controls the animation's acceleration curve.
    var timing: TimingCurve = .automatic

    /// The delay before the animation begins, in seconds.
    var delay: Double = 0

    /// Creates a new value animation for a specific CSS property.
    /// - Parameters:
    ///   - property: The CSS property to animate
    ///   - from: The starting value for the property
    ///   - to: The ending value for the property
    public init(_ property: AnimatableProperty, from: String, to: String) {
        self.property = property
        self.initial = from
        self.final = to
    }

    public init(_ property: AnimatableProperty, value: String) {
        self.property = property
        self.final = value
        // Set appropriate default 'from' value based on property
        switch property {
        case .backgroundColor:
            self.initial = "transparent"
        case .color:
            self.initial = "inherit"
        case .transform:
            self.initial = "none"
        case .opacity:
            self.initial = "1"
        default:
            self.initial = "initial"
        }
    }
}
