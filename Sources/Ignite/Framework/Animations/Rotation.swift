//
// Rotation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Defines the possible directions for 3D rotations
public enum Rotation: Sendable {
    /// Rotates 360 degrees around the Y axis (left to right)
    case right

    /// Rotates -360 degrees around the Y axis (right to left)
    case left

    /// Rotates -360 degrees around the X axis (bottom to top)
    case up

    /// Rotates 360 degrees around the X axis (top to bottom)
    case down
}
