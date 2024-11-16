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
    
    /// Sets the animation duration.
    /// - Parameter duration: The duration in seconds.
    func duration(_ duration: Double) -> Self
    
    /// Sets the animation timing function.
    /// - Parameter function: The timing curve to use.
    func timing(_ function: AnimationCurve) -> Self
    
    /// Sets a delay before the animation begins.
    /// - Parameter delay: The delay duration in seconds.
    func delay(_ delay: Double) -> Self
    
    /// Configures animation repetition.
    /// - Parameters:
    ///   - count: Number of times to repeat. Use `.infinity` for endless repetition.
    ///   - autoreverses: Whether the animation should play in reverse after completing.
    func repeatCount(_ count: Double, autoreverses: Bool) -> Self
    
    /// Adjusts the animation speed by modifying its duration.
    /// - Parameter speed: The speed multiplier. Values greater than 1 increase speed, less than 1 decrease it.
    func speed(_ speed: Double) -> Self
}

public extension Animatable {
    func speed(_ speed: Double) -> Self {
        duration(duration / speed)
    }
    
    func duration(_ duration: Double) -> Self {
        var copy = self
        copy.duration = duration
        return copy
    }
    
    func timing(_ function: AnimationCurve) -> Self {
        var copy = self
        copy.timing = function
        return copy
    }
    
    func delay(_ delay: Double) -> Self {
        var copy = self
        copy.delay = delay
        return copy
    }
    
    func repeatCount(_ count: Double, autoreverses: Bool = true) -> Self {
        var copy = self
        copy.repeatCount = count
        copy.autoreverses = autoreverses
        return copy
    }
}

/// The Ignite animation system deliberately separates concerns between two protocols:
/// `Animation` defines the structural composition of animations through its `body` property,
/// while `Animatable` handles the configurable properties needed for CSS generation.
/// This separation enables better type safety (types can implement just composition or just
/// properties), clearer maintainability (new animation types extend Animation, new properties
/// extend Animatable), and a more intuitive API where Animation describes "what" happens and
/// Animatable describes "how" it happens. This design is particularly evident in how
/// AnimationBuilder converts various animation types into ResolvedAnimation instances for
/// CSS rendering.
