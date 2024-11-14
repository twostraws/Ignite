//
// KeyframeAnimation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that defines a multi-step animation using keyframes.
///
/// `KeyframeAnimation` allows you to create complex animations by defining multiple frames,
/// each representing a specific point in the animation timeline.
///
/// Example:
/// ```swift
/// KeyframeAnimation {
///     Frame("0%") {
///         StandardAnimation(property: "transform", from: "scale(1)", to: "scale(1)")
///     }
///     Frame("50%") {
///         StandardAnimation(property: "transform", from: "scale(1)", to: "scale(1.2)")
///     }
///     Frame("100%") {
///         StandardAnimation(property: "transform", from: "scale(1.2)", to: "scale(1)")
///     }
/// }
/// ```
public struct KeyframeAnimation: Animation, Animatable {
    /// The unique identifier for this keyframe animation
    public let name: String
    
    /// The collection of frames that define the animation sequence
    var frames: [Frame]
    
    /// The number of times to repeat the animation sequence
    public var repeatCount: Double? = nil
    
    /// The delay in seconds before the animation begins
    public var delay: Double = 0
    
    /// The timing function that controls the animation's acceleration curve
    public var timing: AnimationCurve = .easeInOut
    
    /// The duration of the complete animation sequence in seconds
    public var duration: Double = 1
    
    /// The event that triggers this animation
    public var trigger: AnimationTrigger = .hover
    
    /// Whether the animation should play in reverse after completing
    public var autoreverses: Bool = false
    
    /// Creates a new keyframe animation with the specified name and frames.
    /// - Parameters:
    ///   - name: A unique identifier for this animation
    ///   - content: A closure that returns an array of `Frame` instances defining the animation sequence
    public init(_ name: String, @AnimationBuilder content: () -> [Frame]) {
        self.name = name
        self.frames = content()
    }
    
    public var body: some Animation { self }
}
