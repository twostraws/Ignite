//
// ResponsiveValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A collection of values that scale across responsive breakpoints
public struct ResponsiveValues<Value> {
    /// The base value for extra small screens (<576px)
    public let xSmall: Value?

    /// The value for small screens (≥576px)
    public let small: Value

    /// The value for medium screens (≥768px)
    public let medium: Value

    /// The value for large screens (≥992px)
    public let large: Value

    /// The value for extra large screens (≥1200px)
    public let xLarge: Value

    /// The value for extra extra large screens (≥1400px)
    public let xxLarge: Value

    /// Creates a new collection of responsive values
    /// - Parameters:
    ///   - xSmall: The base value for extra small screens. Pass `nil` to inherit from small.
    ///   - small: The value for small screens
    ///   - medium: The value for medium screens
    ///   - large: The value for large screens
    ///   - xLarge: The value for extra large screens
    ///   - xxLarge: The value for extra extra large screens
    public init(
        xSmall: Value? = nil,
        small: Value,
        medium: Value,
        large: Value,
        xLarge: Value,
        xxLarge: Value
    ) {
        self.xSmall = xSmall
        self.small = small
        self.medium = medium
        self.large = large
        self.xLarge = xLarge
        self.xxLarge = xxLarge
    }
}
