//
// AnimationValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Represents a specific CSS animation property with its initial and final states
public struct AnimationValue: Hashable {
    /// The name of the CSS property to animate (e.g., "transform", "color", "opacity")
    let name: String

    /// The starting value of the property when the animation begins
    /// - Note: This value is also used as the resting state for reversible animations
    let initial: String

    /// The ending value of the property when the animation completes
    /// - Note: For hover/click animations, this is the active state value
    let final: String
}
