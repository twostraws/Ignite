//
// ColorArea.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Specifies which color property to animate
public enum ColorArea: Sendable {
    /// The foreground color
    case foreground
    /// The background color
    case background

    var property: AnimatableProperty {
        switch self {
        case .foreground: .color
        case .background: .backgroundColor
        }
    }
}
