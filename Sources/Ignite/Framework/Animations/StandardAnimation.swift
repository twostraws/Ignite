//
// StandardAnimation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A basic animation type that transitions a single CSS property from one value to another.
///
/// `StandardAnimation` represents the simplest form of animation in Ignite, handling
/// transitions of individual CSS properties like opacity, transform, or color.
public struct StandardAnimation: Animation, Animatable {
    /// The starting value for the animated property
    var from: String
    
    /// The ending value for the animated property
    var to: String
    
    /// The CSS property to animate (e.g., "opacity", "transform", "background-color")
    var property: String
    
    /// The number of times to repeat the animation
    /// When set to `.infinity`, the animation will loop indefinitely
    public var repeatCount: Double? = nil
    
    /// The time to wait before starting the animation, in seconds
    public var delay: Double = 0
    
    /// The easing function to use for the animation
    public var timing: AnimationCurve = .easeInOut
    
    /// The total duration of the animation in seconds
    public var duration: Double = 1
    
    /// The event that triggers this animation (hover, click, or appear)
    public var trigger: AnimationTrigger = .hover
    
    /// Whether the animation should play in reverse after completing
    public var autoreverses: Bool = false
    
    /// Creates a new standard animation for a specific CSS property.
    /// - Parameters:
    ///   - property: The CSS property to animate
    ///   - from: The starting value for the property
    ///   - to: The ending value for the property
    public init(property: String, from: String, to: String) {
        self.property = property
        self.from = from
        self.to = to
    }
    
    /// The animation's body, required by the Animation protocol
    public var body: some Animation { self }
}
