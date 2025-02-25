//
// AnimationOption.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that defines configuration options for animations,
/// such as repeat count and duration.
public enum AnimationOption: Hashable, Sendable {
    /// How many times the animation repeats
    case repeatCount(Double)

    /// Controls how styles are applied before and after the animation
    case fillMode(FillMode)

    /// Controls whether the animation plays forwards, backwards, or alternates
    case direction(AnimationDirection)

    /// The duration of the animation in seconds
    case duration(Double)

    /// The timing function that controls the animation's acceleration curve
    case timing(TimingCurve)

    /// The delay before the animation starts in seconds
    case delay(Double)

    /// Adjusts the animation speed by modifying its duration
    case speed(Double)

    var optionType: OptionType {
        switch self {
        case .repeatCount: .repeatCount
        case .fillMode: .fillMode
        case .direction: .direction
        case .duration: .duration
        case .timing: .timing
        case .delay: .delay
        case .speed: .speed
        }
    }

    enum OptionType: Hashable {
        case repeatCount, fillMode, direction, duration, timing, delay, speed
    }
}
