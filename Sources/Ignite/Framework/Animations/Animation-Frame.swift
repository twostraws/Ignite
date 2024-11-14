//
// Animation-Frame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A single keyframe in an animation sequence.
///
/// `Frame` represents a specific point in an animation timeline, defining one or more property
/// transformations at a given position (percentage or keyword).
///
/// Example:
/// ```swift
/// Frame("50%") {
///     StandardAnimation(property: "transform", from: "scale(1)", to: "scale(1.2)")
/// }
/// ```
public struct Frame: Animation, Animatable {
    /// The position in the animation timeline (e.g., "0%", "50%", "100%")
    let position: String
    /// The property transformations to apply at this position
    var animations: [StandardAnimation]
    
    /// The number of times to repeat the animation
    public var repeatCount: Double? = nil
    /// The delay before starting the animation, in seconds
    public var delay: Double = 0
    /// The timing function for the animation
    public var timing: AnimationCurve = .easeInOut
    /// The duration of the animation in seconds
    public var duration: Double = 1
    /// The event that triggers the animation
    public var trigger: AnimationTrigger = .hover
    /// Whether the animation should reverse after completion
    public var autoreverses: Bool = false
    
    /// Creates a frame with a single animation using a closure
    public init(_ position: String, @AnimationBuilder animation: () -> StandardAnimation) {
        self.position = position
        self.animations = [animation()]
    }
    
    /// Creates a frame with a single predefined animation
    public init(_ position: String, animation: StandardAnimation) {
        self.position = position
        self.animations = [animation]
    }
    
    public var body: some Animation { self }
}
