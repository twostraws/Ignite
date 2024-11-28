//
// Animation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A type that defines a multi-step animation using keyframes.
///
/// `Animation` allows you to create complex animations by defining multiple frames,
/// each representing a specific point in the animation timeline.
///
/// Example:
/// ```swift
/// Animation()
///    .keyframe(0%) { animation in
///        animation.color(.background, to: .blue)
///        animation.color(.foreground, to: .yellow)
///    }
///    .keyframe(100%) { animation in
///        animation.color(.background, to: .red)
///        animation.color(.foreground, to: .white)
///    }
/// ```
public struct Animation: Animatable {
    /// The collection of frames that define the animation sequence
    var frames: [Frame]

    /// Controls whether the animation plays forwards, backwards, or alternates
    var direction: AnimationDirection = .automatic

    /// Determines how styles are applied before and after the animation executes
    var fillMode: FillMode = .none

    /// The number of times to repeat the animation sequence
    var repeatCount: Double = 1

    /// The delay in seconds before the animation begins
    public var delay: Double = 0

    /// The timing function that controls the animation's acceleration curve
    public var timing: TimingCurve = .easeInOut

    /// The duration of the complete animation sequence in seconds
    public var duration: Double = 1

    /// The event that triggers this animation
    public var trigger: AnimationTrigger = .hover

    /// Additional non-animated CSS properties
    public var staticProperties: OrderedSet<AttributeValue> = []

    /// Creates a new keyframe animation.
    public init() {
        self.frames = []
    }

    /// Creates a new keyframe animation.
    init(frames: [Frame]) {
        self.frames = frames
    }
}

public extension Animation {
    /// Adds a new keyframe to the animation sequence at the specified position
    /// - Parameters:
    ///   - position: The position in the timeline (e.g., "0%", "50%", "100%")
    ///   - content: A closure that configures the frame's animations
    /// - Returns: A copy of the animation with the new frame added
    func keyframe(_ position: Percentage, content: (inout Frame) -> Void) -> Animation {
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

    /// Configures animation repetition.
    /// - Parameters:
    ///   - count: Number of times to repeat. Use `.infinity` for endless repetition.
    ///   - autoreverses: Whether the animation should play in reverse after completing.
    func repeatCount(_ count: Double) -> Self {
        var copy = self
        copy.repeatCount = count
        return copy
    }

    /// Sets the fill mode for the animation, controlling how styles are applied before and after execution
    /// - Parameter mode: The fill mode to use (.none, .forwards, .backwards, or .both)
    /// - Returns: A new animation instance with the updated fill mode
    func fillMode(_ mode: FillMode) -> Self {
        var copy = self
        copy.fillMode = mode
        return copy
    }

    /// Sets the direction for the animation, controlling whether it plays forwards, backwards, or alternates
    /// - Parameter direction: The direction to use (.normal, .reverse, .alternate, or .alternateReverse)
    /// - Returns: A new animation instance with the updated direction
    func direction(_ direction: AnimationDirection) -> Self {
        var copy = self
        copy.direction = direction
        return copy
    }

    /// Adds an additional CSS style property to the animation
    /// - Parameter style: The CSS style to add
    /// - Returns: A modified animation with the additional style
    func baseProperty(_ style: AttributeValue) -> Self {
        var copy = self
        copy.staticProperties.append(style)
        return copy
    }
}

public extension Animation {
    /// Creates a bouncing animation.
    static var bounce: Self {
        Animation()
            .keyframe(0%) { frame in
                frame.custom(.transform, value: "translateY(0)")
            }
            .keyframe(50%) { frame in
                frame.custom(.transform, value: "translateY(-20px)")
            }
            .keyframe(100%) { frame in
                frame.custom(.transform, value: "translateY(0)")
            }
            .duration(0.5)
            .timing(.custom("cubic-bezier(0.36, 0, 0.66, -0.56)"))
    }

    /// Adds a bounce effect to the current animation
    func bounce() -> Self {
        self.keyframe(0%) { frame in
            frame.custom(.transform, value: "translateY(0)")
        }
        .keyframe(50%) { frame in
            frame.custom(.transform, value: "translateY(-20px)")
        }
        .keyframe(100%) { frame in
            frame.custom(.transform, value: "translateY(0)")
        }
        .duration(0.5)
        .timing(.custom("cubic-bezier(0.36, 0, 0.66, -0.56)"))
    }

    /// Creates a shaking animation.
    static var wiggle: Self {
        Animation()
            .keyframe(0%) { frame in
                frame.custom(.transform, value: "translateX(0)")
            }
            .keyframe(25%) { frame in
                frame.custom(.transform, value: "translateX(10px)")
            }
            .keyframe(50%) { frame in
                frame.custom(.transform, value: "translateX(0)")
            }
            .keyframe(75%) { frame in
                frame.custom(.transform, value: "translateX(10px)")
            }
            .keyframe(100%) { frame in
                frame.custom(.transform, value: "translateX(0)")
            }
            .duration(0.5)
            .timing(.automatic)
            .repeatCount(3)
    }

    /// Adds a wiggle effect to the current animation
    func wiggle() -> Self {
        self.keyframe(0%) { frame in
            frame.custom(.transform, value: "translateX(0)")
        }
        .keyframe(25%) { frame in
            frame.custom(.transform, value: "translateX(10px)")
        }
        .keyframe(50%) { frame in
            frame.custom(.transform, value: "translateX(0)")
        }
        .keyframe(75%) { frame in
            frame.custom(.transform, value: "translateX(10px)")
        }
        .keyframe(100%) { frame in
            frame.custom(.transform, value: "translateX(0)")
        }
        .duration(0.5)
        .timing(.automatic)
        .repeatCount(3)
    }
}
