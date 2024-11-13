//
// Animatable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines the requirements for an animation
public protocol Animatable {
    /// The duration of the animation in seconds
    var duration: Double { get }
    
    /// The CSS timing function to use for the animation
    var cssTimingFunction: String { get }
    
    /// The delay before the animation starts in seconds
    var delay: Double { get }
    
    /// The number of times to repeat the animation (nil for no repeat)
    var repeatCount: Double? { get }
    
    /// Whether the animation should reverse direction on alternate cycles
    var autoreverses: Bool { get }
    
    /// The properties being animated and their values
    var properties: [AnimationValue] { get }
    
    /// Sets the duration of the animation
    func duration(_ duration: Double) -> Self
    
    /// Adjusts the speed of the animation (duration is divided by speed)
    func speed(_ speed: Double) -> Self
    
    /// Sets the delay before the animation starts
    func delay(_ delay: Double) -> Self
    
    /// Makes the animation repeat indefinitely
    func repeatForever(autoreverses: Bool) -> Self
    
    /// Sets a specific number of times to repeat the animation
    func repeatCount(_ count: Int, autoreverses: Bool) -> Self
    
    /// Sets whether the animation should reverse on alternate cycles
    func autoReverse(_ autoreverses: Bool) -> Self
    
    /// Creates a linear timing animation
    static var linear: Self { get }
    
    /// Creates a linear timing animation with specified duration
    static func linear(duration: Double) -> Self
    
    /// Creates an ease-in timing animation
    static var easeIn: Self { get }
    
    /// Creates an ease-in timing animation with specified duration
    static func easeIn(duration: Double) -> Self
    
    /// Creates an ease-out timing animation
    static var easeOut: Self { get }
    
    /// Creates an ease-out timing animation with specified duration
    static func easeOut(duration: Double) -> Self
    
    /// Creates an ease-in-out timing animation
    static var easeInOut: Self { get }
    
    /// Creates an ease-in-out timing animation with specified duration
    static func easeInOut(duration: Double) -> Self
    
    /// Creates a spring timing animation with customizable parameters
    static func spring(dampingRatio: Double, velocity: Double) -> Self
}
