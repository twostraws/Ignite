//
// Breakpoint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A representation of standard responsive design breakpoints.
enum Breakpoint: Sendable, Hashable, CaseIterable, Comparable {
    /// Extra small screens (up to 576px)
    case xSmall

    /// Small screens (576px)
    case small

    /// Medium screens (768px)
    case medium

    /// Large screens (992px)
    case large

    /// Extra large screens (1200px)
    case xLarge

    /// Extra extra large screens (1400px)
    case xxLarge

    /// Returns the breakpoint infix for Bootstrap classes, or nil for the default (xs) breakpoint
    var infix: String? {
        switch self {
        case .xSmall: nil
        case .small: "sm"
        case .medium: "md"
        case .large: "lg"
        case .xLarge: "xl"
        case .xxLarge: "xxl"
        }
    }

    /// Implements the `Comparable` protocol by comparing the raw pixel widths.
    static func < (lhs: Breakpoint, rhs: Breakpoint) -> Bool {
        // Use the ordinal position in the CaseIterable array for comparison
        let allCases = Breakpoint.allCases
        guard let lhsIndex = allCases.firstIndex(of: lhs),
              let rhsIndex = allCases.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}
