//
// SpacingAmount.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Adaptive spacing amounts that are used by Bootstrap to provide consistency
/// in site design.
public enum SpacingAmount: Int, CaseIterable, Sendable {
    case none = 0
    case xSmall
    case small
    case medium
    case large
    case xLarge
}
