//
// BreakpointQuery.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Applies styles based on viewport width breakpoints
public struct BreakpointQuery: Query, Sendable {
    /// The breakpoint value type
    private enum Value: Hashable, Equatable {
        case small
        case medium
        case large
        case xLarge
        case xxLarge
        case custom(LengthUnit)
    }

    private let value: Value
    private let theme: (any Theme)?

    /// Small breakpoint (typically ≥576px)
    public static let small = BreakpointQuery(value: .small)
    /// Medium breakpoint (typically ≥768px)
    public static let medium = BreakpointQuery(value: .medium)
    /// Large breakpoint (typically ≥992px)
    public static let large = BreakpointQuery(value: .large)
    /// Extra large breakpoint (typically ≥1200px)
    public static let xLarge = BreakpointQuery(value: .xLarge)
    /// Extra extra large breakpoint (typically ≥1400px)
    public static let xxLarge = BreakpointQuery(value: .xxLarge)

    /// Creates a custom breakpoint query
    /// - Parameter value: The length unit for the breakpoint
    /// - Returns: A breakpoint query with the custom value
    public static func custom(_ value: LengthUnit) -> BreakpointQuery {
        BreakpointQuery(value: .custom(value))
    }

    /// Creates a breakpoint query with a specific theme
    /// - Parameter theme: The theme to use for breakpoint values
    /// - Returns: A new breakpoint query with the theme
    public func withTheme(_ theme: any Theme) -> BreakpointQuery {
        BreakpointQuery(value: value, theme: theme)
    }

    private init(value: Value, theme: (any Theme)? = nil) {
        self.value = value
        self.theme = theme
    }

    /// Creates a breakpoint from a string identifier.
    init?(_ breakpoint: Breakpoint) {
        switch breakpoint {
        case .small: self.value = .small
        case .medium: self.value = .medium
        case .large: self.value = .large
        case .xLarge: self.value = .xLarge
        case .xxLarge: self.value = .xxLarge
        default: return nil
        }
        self.theme = nil
    }

    /// The raw CSS media query string.
    /// If a theme is set, uses theme-specific values; otherwise uses Ignite's default values.
    public var condition: String {
        if let theme = theme {
            let responsiveValues = theme.breakpoints.values
            let breakpointValue = switch value {
            case .small: (responsiveValues[.small] ?? Bootstrap.smallBreakpoint).stringValue
            case .medium: (responsiveValues[.medium] ?? Bootstrap.mediumBreakpoint).stringValue
            case .large: (responsiveValues[.large] ?? Bootstrap.largeBreakpoint).stringValue
            case .xLarge: (responsiveValues[.xLarge] ?? Bootstrap.xLargeBreakpoint).stringValue
            case .xxLarge: (responsiveValues[.xxLarge] ?? Bootstrap.xxLargeBreakpoint).stringValue
            case .custom(let value): value.stringValue
            }
            return "min-width: \(breakpointValue)"
        } else {
            let breakpointValue = switch value {
            case .small: Bootstrap.smallBreakpoint.stringValue
            case .medium: Bootstrap.mediumBreakpoint.stringValue
            case .large: Bootstrap.largeBreakpoint.stringValue
            case .xLarge: Bootstrap.xLargeBreakpoint.stringValue
            case .xxLarge: Bootstrap.xxLargeBreakpoint.stringValue
            case .custom(let value): value.stringValue
            }
            return "min-width: \(breakpointValue)"
        }
    }

    public static func == (lhs: BreakpointQuery, rhs: BreakpointQuery) -> Bool {
        if lhs.value != rhs.value {
            return false
        }

        switch (lhs.theme, rhs.theme) {
        case (nil, nil):
            return true
        case let (lhsTheme?, rhsTheme?):
            return lhsTheme.cssID.starts(with: rhsTheme.cssID)
        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        if let theme = theme {
            hasher.combine(theme.cssID)
        }
    }
}

extension BreakpointQuery: CaseIterable {
    public static var allCases: [BreakpointQuery] {
        [.small, .medium, .large, .xLarge, .xxLarge]
    }
}

extension BreakpointQuery: MediaFeature {
    public var description: String {
        condition
    }
}
