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
///    .frame(0) { content in
///        content.backgroundColor("blue")
///        content.color("yellow")
///    }
///    .frame(1) { content in
///        content.backgroundColor("red")
///        content.color("white")
///    }
/// ```
public struct KeyframeAnimation: Animation, Animatable {
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
    public init(@AnimationBuilder content: () -> [Frame]) {
        self.frames = content()
    }
    
    /// Creates a new keyframe animation.
    public init() {
        self.frames = []
    }
    
    public var body: some Animation { self }
}

public extension KeyframeAnimation {
    /// Adds a new keyframe to the animation sequence at the specified position
    /// - Parameters:
    ///   - position: The position in the timeline (e.g., 0%, 50%, 100%)
    ///   - content: A closure that configures the frame's animations
    /// - Returns: A copy of the animation with the new frame added
    func frame(_ position: Percentage, content: (inout FrameBuilder) -> Void) -> KeyframeAnimation {
        precondition(
            position >= 0% && position <= 100%,
            "Animation frame position must be between 0% and 100%, got \(position)"
        )
        var copy = self
        var frameBuilder = FrameBuilder()
        content(&frameBuilder)
        let frame = Frame(position, animations: frameBuilder.animations)
        copy.frames.append(frame)
        return copy
    }
}

public struct FrameBuilder {
    var animations: [BasicAnimation] = []
    
    public mutating func backgroundColor(_ value: String) {
        animations.append(BasicAnimation(.backgroundColor, value: value))
    }
    
    public mutating func color(_ value: String) {
        animations.append(BasicAnimation(.color, value: value))
    }
    
    public mutating func custom(_ property: AnimatableProperty, value: String) {
        animations.append(BasicAnimation(property, value: value))
    }
}
