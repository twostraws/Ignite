//
// Animation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import OrderedCollections

/// A type that defines a multi-step animation using keyframes.
///
/// `Animation` allows you to create complex animations by defining multiple frames,
/// each representing a specific point in the animation timeline.
///
/// Example:
/// ```swift
/// Text("Animation")
///     .animation(.click) { keyframe in
///         keyframe(0%)
///             .color(.background, to: .blue)
///         keyframe(100%)
///             .color(.foreground, to: .yellow)
///     }
/// ```
public struct Animation: Animatable, Hashable {
    /// The collection of frames that define the animation sequence
    var frames: [Frame]

    /// Controls whether the animation plays forwards, backwards, or alternates
    var direction: AnimationDirection = .automatic

    /// Determines how styles are applied before and after the animation executes
    var fillMode: FillMode = .none

    /// The number of times to repeat the animation sequence
    var repeatCount: Double = 1

    /// The delay in seconds before the animation begins
    var delay: Double = 0

    /// The timing function that controls the animation's acceleration curve
    var timing: TimingCurve = .easeInOut

    /// The duration of the complete animation sequence in seconds
    var duration: Double = 1

    /// Creates a new keyframe animation.
    init() {
        self.frames = []
    }

    init(options: [AnimationOption], frames: [Keyframe]) {
        self.frames = frames
        with(options)
    }

    /// Creates a new keyframe animation.
    init(frames: [Frame]) {
        self.frames = frames
    }
}

extension Animation {
    mutating func with(_ options: [AnimationOption]) {
        var lastOptionByType: [AnimationOption.OptionType: AnimationOption] = [:]

        // Collect last option of each type
        for option in options {
            lastOptionByType[option.optionType] = option
        }

        // Apply the final options
        for option in lastOptionByType.values {
            switch option {
            case .repeatCount(let value):
                repeatCount = value
            case .fillMode(let value):
                fillMode = value
            case .direction(let value):
                direction = value
            case .duration(let value):
                duration = value
            case .timing(let value):
                timing = value
            case .delay(let value):
                delay = value
            case .speed(let value):
                duration /= value
            }
        }
    }
}

public extension Animation {
    /// Creates a bouncing animation.
    static var bounce: Self {
        Animation(
            options: [
                .duration(0.5),
                .timing(.custom("cubic-bezier(0.36, 0, 0.66, -0.56)"))
            ],
            frames: [
                Keyframe(0%).custom(.transform, value: "translateY(0)"),
                Keyframe(50%).custom(.transform, value: "translateY(-20px)"),
                Keyframe(100%).custom(.transform, value: "translateY(0)")
            ]
        )
    }

    /// Adds a bounce effect to the current animation
    func bounce() -> Self {
        Animation(
            options: [
                .duration(0.5),
                .timing(.custom("cubic-bezier(0.36, 0, 0.66, -0.56)"))
            ],
            frames: [
                Keyframe(0%).custom(.transform, value: "translateY(0)"),
                Keyframe(50%).custom(.transform, value: "translateY(-20px)"),
                Keyframe(100%).custom(.transform, value: "translateY(0)")
            ]
        )
    }

    /// Creates a shaking animation.
    static var wiggle: Self {
        Animation(
            options: [
                .duration(0.5),
                .timing(.automatic),
                .repeatCount(3)
            ],
            frames: [
                Keyframe(0%).custom(.transform, value: "translateX(0)"),
                Keyframe(25%).custom(.transform, value: "translateX(10px)"),
                Keyframe(50%).custom(.transform, value: "translateX(0)"),
                Keyframe(75%).custom(.transform, value: "translateX(10px)"),
                Keyframe(100%).custom(.transform, value: "translateX(0)")
            ]
        )
    }

    /// Adds a wiggle effect to the current animation
    func wiggle() -> Self {
        Animation(
            options: [
                .duration(0.5),
                .timing(.automatic),
                .repeatCount(3)
            ],
            frames: [
                Keyframe(0%).custom(.transform, value: "translateX(0)"),
                Keyframe(25%).custom(.transform, value: "translateX(10px)"),
                Keyframe(50%).custom(.transform, value: "translateX(0)"),
                Keyframe(75%).custom(.transform, value: "translateX(10px)"),
                Keyframe(100%).custom(.transform, value: "translateX(0)")
            ]
        )
    }
}
