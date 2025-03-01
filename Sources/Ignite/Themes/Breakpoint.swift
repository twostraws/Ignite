//
// Breakpoint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A representation of standard responsive design breakpoints.
enum Breakpoint: String, Sendable, Hashable, CaseIterable, Comparable {
    /// Extra small screens (up to 576px)
    case xSmall = "xs"

    /// Small screens (576px)
    case small = "sm"

    /// Medium screens (768px)
    case medium = "md"

    /// Large screens (992px)
    case large = "lg"

    /// Extra large screens (1200px)
    case xLarge = "xl"

    /// Extra extra large screens (1400px)
    case xxLarge = "xxl"

    /// The default width associated with each breakpoint.
    var defaultWidth: LengthUnit {
        switch self {
        case .xSmall: .px(576)
        case .small: .px(576)
        case .medium: .px(768)
        case .large: .px(992)
        case .xLarge: .px(1200)
        case .xxLarge: .px(1400)
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
