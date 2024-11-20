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
/// KeyframeAnimation()
///    .frame(0%) { content in
///        content.color(.background, to: .blue)
///        content.color(.foreground, to: .yellow)
///    }
///    .frame(100%) { content in
///        content.color(.background, to: .red)
///        content.color(.foreground, to: .white)
///    }
/// ```
public struct KeyframeAnimation: Animation {
    /// The collection of frames that define the animation sequence
    var frames: [Frame]
    
    /// The number of times to repeat the animation sequence
    public var repeatCount: Double = 1
    
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
    
    /// Additional non-animated CSS properties
    public var staticProperties: OrderedSet<AttributeValue> = []
    
    /// Creates a new keyframe animation.
    public init() {
        self.frames = []
    }
    
    /// Adds an additional CSS style property to the animation
    /// - Parameter style: The CSS style to add
    /// - Returns: A modified animation with the additional style
    public func baseProperty(_ style: AttributeValue) -> Self {
        var copy = self
        copy.staticProperties.append(style)
        return copy
    }
}

public extension KeyframeAnimation {
    /// Adds a new keyframe to the animation sequence at the specified position
    /// - Parameters:
    ///   - position: The position in the timeline (e.g., "0%", "50%", "100%")
    ///   - content: A closure that configures the frame's animations
    /// - Returns: A copy of the animation with the new frame added
    func frame(_ position: Percentage, content: (inout Frame) -> Void) -> KeyframeAnimation {
        precondition(
            position >= 0% && position <= 100%,
            "Animation frame position must be between 0% and 100%, got \(position)"
        )
        var copy = self
        var frame = Frame(position, animations: [])
        content(&frame)
        copy.frames.append(frame)
        return copy
    }
}
