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
    struct Frame {
        /// The position in the animation timeline, between `0%` and `100%`
        let position: Percentage
        
        /// The property transformations to apply at this position
        var animations: [AnimationData]
        
        /// Creates a frame with a single predefined animation
        public init(_ position: Percentage, animations: [AnimationData]) {
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
        animations.append(AnimationData(area.property, value: value.description))
    }
    
    /// Sets the scale transform for this keyframe
    /// - Parameter value: The scale factor to animate to (e.g., 1.5 for 150% size)
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func scale(_ value: Double) {
        animations.append(AnimationData(.transform, value: "scale(\(value))"))
    }
       
    /// Sets the rotation transform for this keyframe
    /// - Parameters:
    ///   - angle: The angle to rotate by
    ///   - anchor: The point around which to rotate (defaults to center)
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func rotate(_ angle: Angle, anchor: AnchorPoint = .center) {
        animations.append(AnimationData(.transformOrigin, value: anchor.value))
        animations.append(AnimationData(.transform, value: "rotate(\(angle.value))"))
    }
    
    /// Sets a custom style transformation for this keyframe
    /// - Parameter property: The CSS property to animate
    /// - Parameter value: The CSS value
    /// - Note: This will be animated between frames in the keyframe sequence
    mutating func custom(_ property: AnimatableProperty, value: String) {
        animations.append(AnimationData(property, value: value))
    }
}
