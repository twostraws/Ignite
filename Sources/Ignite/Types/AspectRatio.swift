//
// AspectRatio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Specific aspect ratios that are commonly used
public enum AspectRatio: String, CaseIterable, Sendable {
    /// A square aspect ratio.
    case square = "1x1"

    /// A 4:3 aspect ratio.
    case r4x3 = "4x3"

    /// A 16:9 aspect ratio.
    case r16x9 = "16x9"

    /// A 21:9 aspect ratio.
    case r21x9 = "21x9"
}
