//
// Animatable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines the core animation capabilities for Ignite's animation system.
public protocol Animation {
    /// The event that triggers the animation.
    var trigger: AnimationTrigger { get set }
    
    /// Additional non-animated CSS properties
    var staticProperties: OrderedSet<AttributeValue> { get set }
    
    /// A unique identifier generated from the animation type name
    static var id: String { get }
    
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

public extension Animation {
    static var id: String {
        String(describing: self).truncatedHash
    }
}

public extension KeyframeAnimation {
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
