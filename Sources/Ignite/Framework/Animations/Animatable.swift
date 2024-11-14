//
// Animatable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the core animation capabilities for Ignite's animation system.
///
/// The `Animatable` protocol provides a foundation for creating animations with customizable
/// timing, duration, and trigger behaviors. Types conforming to this protocol can be used
/// with the `animation()` modifier to create dynamic animations.
///
/// Example usage:
/// ```swift
/// struct FadeInAnimation: Animation, Animatable {
///     var duration: Double = 1.0
///     var timing: AnimationTiming = .easeOut
///     var trigger: AnimationTrigger = .appear
///
///     var body: some Animation {
///         StandardAnimation(property: "opacity", from: "0", to: "1")
///     }
/// }
/// ```
///
/// - Note: This protocol is typically used in conjunction with the `Animation` protocol to create
///         custom animations that can be applied to HTML elements.
public protocol Animatable {
    /// The duration of the animation in seconds.
    var duration: Double { get set }
    
    /// The timing function that controls the animation's acceleration curve.
    var timing: AnimationCurve { get set }
    
    /// The event that triggers the animation.
    var trigger: AnimationTrigger { get set }
    
    /// The number of times the animation should repeat.
    /// - Note: Set to `nil` for no repetition, or `.infinity` for endless repetition.
    var repeatCount: Double? { get set }
    
    /// The delay before the animation begins, in seconds.
    var delay: Double { get set }
    
    /// Whether the animation should play in reverse after completing.
    var autoreverses: Bool { get set }
}
