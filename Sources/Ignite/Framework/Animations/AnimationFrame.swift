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
    /// KeyframeAnimation.Frame(50%) {
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
    /// Sets a color for this keyframe
    /// - Parameters:
    ///   - area: Which color property to animate (text or background). Default is `.foreground`.
    ///   - value: The color to animate to
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func color(_ area: ColorArea = .foreground, to value: Color) {
        animations.append(BasicAnimation(area.property, value: value.description))
    }
    
    /// Sets the scale transform for this keyframe
    /// - Parameter value: The scale factor to animate to (e.g., 1.5 for 150% size)
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func scale(_ value: Double) {
        animations.append(BasicAnimation(.transform, value: "scale(\(value))"))
    }
       
    /// Sets the rotation transform for this keyframe
    /// - Parameters:
    ///   - angle: The angle to rotate by
    ///   - anchor: The point around which to rotate (defaults to center)
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func rotate(_ angle: Angle, anchor: AnchorPoint = .center) {
        animations.append(
            BasicAnimation(.transform, value: "rotate(\(angle.value))")
                .baseProperty(.init(name: .transformOrigin, value: anchor.value))
        )
    }
    
    /// Sets a custom style transformation for this keyframe
    /// - Parameter property: The CSS property to animate
    /// - Parameter value: The CSS value
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func custom(_ property: AnimatableProperty, value: String) {
        animations.append(BasicAnimation(property, value: value))
    }
}
