//
// SiteWidthConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A configuration that defines maximum content widths at different breakpoints
public struct SiteWidthConfiguration: Responsive, Sendable, Equatable, Hashable {
    /// The base width for extra small screens (<576px)
    public let xSmall: LengthUnit?

    /// The maximum width for small screens (≥576px)
    public let small: LengthUnit

    /// The maximum width for medium screens (≥768px)
    public let medium: LengthUnit

    /// The maximum width for large screens (≥992px)
    public let large: LengthUnit

    /// The maximum width for extra large screens (≥1200px)
    public let xLarge: LengthUnit

    /// The maximum width for extra extra large screens (≥1400px)
    public let xxLarge: LengthUnit

    /// The default Bootstrap container widths
    public static var defaults: ResponsiveValues<LengthUnit> {
        ResponsiveValues(
            small: Bootstrap.Containers.small,
            medium: Bootstrap.Containers.medium,
            large: Bootstrap.Containers.large,
            xLarge: Bootstrap.Containers.xLarge,
            xxLarge: Bootstrap.Containers.xxLarge
        )
    }

    /// Creates a new site width configuration with resolved values
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
