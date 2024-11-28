//
// FillMode.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Specifies how values persist before and after an animation
public enum FillMode: String, Sendable {
    /// No fill mode needed
    case none
    /// Retains the values set by the last keyframe
    case forwards
    /// Retains the values set by the first keyframe
    case backwards
    /// Retains values before and after animation
    case both
}
