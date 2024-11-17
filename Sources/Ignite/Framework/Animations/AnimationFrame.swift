//
// AnimationFrame.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public typealias AnimationFrame = KeyframeAnimation.Frame

public extension KeyframeAnimation {
    /// A single keyframe in an animation sequence.
    ///
    /// `Frame` represents a specific point in an animation timeline, defining one or more property
    /// transformations at a given position (percentage or keyword).
    ///
    /// Example:
    /// ```swift
    /// KeyframeAnimation.Frame(0.5) {
    ///     BasicAnimation(.transform, value: "scale(1.2)")
    /// }
    /// ```
    struct Frame: Animation, Animatable {
        /// The content of this animation.
        public var body: some Animation { self }
        
        /// The position in the animation timeline, between `0%` and `100%`
        let position: Percentage
        
        /// The property transformations to apply at this position
        var animations: [BasicAnimation]
        
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
        public init(_ position: Percentage, @AnimationBuilder animation: () -> [BasicAnimation]) {
            precondition(
                position >= 0% && position <= 100%,
                "Animation frame position must be between 0% and 100%, got \(position)%"
            )
            self.position = position
            self.animations = animation()
        }
        
        /// Creates a frame with a single predefined animation
        public init(_ position: Percentage, animations: [BasicAnimation]) {
            precondition(
                position >= 0% && position <= 100%,
                "Animation frame position must be between 0% and 100%, got \(position)%"
            )
            self.position = position
            self.animations = animations
        }
    }
}

public extension KeyframeAnimation.Frame {
    /// Sets the background color for this keyframe
    /// - Parameter value: The CSS color value (e.g., "blue", "#FF0000", "rgb(255, 0, 0)")
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func backgroundColor(_ value: String) {
        animations.append(BasicAnimation(.backgroundColor, value: value))
    }
    
    /// Sets the text color for this keyframe
    /// - Parameter value: The CSS color value (e.g., "yellow", "#FFFF00", "rgb(255, 255, 0)")
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func color(_ value: String) {
        animations.append(BasicAnimation(.color, value: value))
    }
    
    /// Sets a custom style transformation for this keyframe
    /// - Parameter property: The CSS property to animate
    /// - Parameter value: The CSS value
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func custom(_ property: AnimatableProperty, value: String) {
        animations.append(BasicAnimation(property, value: value))
    }
}
