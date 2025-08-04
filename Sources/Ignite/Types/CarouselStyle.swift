//
// CarouselStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Whether moving between slides should cause movement or a crossfade.
public enum CarouselStyle: Equatable, Sendable {
    /// Slides should move.
    case move(_ duration: Double, curve: TimingCurve = .easeInOut)

    /// Slides should crossfade.
    case crossfade(_ duration: Double, curve: TimingCurve = .easeInOut)

    /// The default slide movement transition with 1-second duration and ease-in-out curve.
    public static var move: CarouselStyle {
        .move(1, curve: .easeInOut)
    }

    /// The default crossfade transition with 1-second duration and ease-in-out curve.
    public static var crossfade: CarouselStyle {
        .crossfade(1, curve: .easeInOut)
    }
}
