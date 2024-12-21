//
// AnimationDirection.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Specifies the direction of an animation's playback.
public enum AnimationDirection: String, Sendable {
    /// Plays the animation normally from start to finish.
    case automatic = "normal"

    /// Plays the animation in reverse from end to start.
    case reverse = "reverse"

    /// Alternates between forward and reverse playback on each iteration.
    case alternate = "alternate"

    /// Alternates between reverse and forward playback on each iteration.
    case alternateReverse = "alternate-reverse"
}
