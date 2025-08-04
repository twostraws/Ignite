//
// LineSpacing.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Predefined line height values that match Bootstrap's spacing system.
public enum LineSpacing: String, CaseIterable, Sendable {
    /// Single line height (1.0)
    case xSmall = "1"

    /// Compact line height (1.25)
    case small = "sm"

    /// Default line height (1.5)
    case standard = "base"

    /// Relaxed line height (2.0)
    case large = "lg"

    /// The actual multiplier value for this line height
    var value: Double {
        switch self {
        case .xSmall: 1.0
        case .small: 1.25
        case .standard: 1.5
        case .large: 2.0
        }
    }
}
