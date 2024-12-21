//
// Angle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents an angle that can be expressed in different units
public enum Angle: Sendable {
    /// Angle in degrees (e.g., 180 degrees)
    case degrees(Double)

    /// Angle in radians (e.g., π radians)
    case radians(Double)

    /// Angle in turns (e.g., 0.5 turns = 180 degrees)
    case turns(Double)

    /// The CSS value for the angle
    var value: String {
        switch self {
        case .degrees(let value): "\(value)deg"
        case .radians(let value): "\(value)rad"
        case .turns(let value): "\(value)turn"
        }
    }
}
