//
// BreakpointConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A configuration that defines responsive breakpoints for a theme
public struct BreakpointConfiguration: Responsive, Sendable, Equatable, Hashable {
    /// The base breakpoint for extra small screens (<576px)
    public let xSmall: LengthUnit?

    /// The breakpoint for small screens (≥576px)
    public let small: LengthUnit

    /// The breakpoint for medium screens (≥768px)
    public let medium: LengthUnit

    /// The breakpoint for large screens (≥992px)
    public let large: LengthUnit

    /// The breakpoint for extra large screens (≥1200px)
    public let xLarge: LengthUnit

    /// The breakpoint for extra extra large screens (≥1400px)
    public let xxLarge: LengthUnit

    /// The default Bootstrap breakpoint values
    public static var defaults: ResponsiveValues<LengthUnit> {
        ResponsiveValues(
            small: Bootstrap.Breakpoints.small,
            medium: Bootstrap.Breakpoints.medium,
            large: Bootstrap.Breakpoints.large,
            xLarge: Bootstrap.Breakpoints.xLarge,
            xxLarge: Bootstrap.Breakpoints.xxLarge
        )
    }

    /// Creates a new breakpoint configuration with resolved values
    /// - Parameter values: The resolved values for each breakpoint
    public init(values: ResponsiveValues<LengthUnit>) {
        self.xSmall = values.xSmall
        self.small = values.small
        self.medium = values.medium
        self.large = values.large
        self.xLarge = values.xLarge
        self.xxLarge = values.xxLarge
    }
}
