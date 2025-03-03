//
// ResponsiveValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A type that defines how a value changes across different screen sizes.
///
/// `ResponsiveValues` allows you to specify different values for each breakpoint, with an optional
/// base size that can cascade up through larger breakpoints. Values are inherited from the largest
/// specified smaller breakpoint when not explicitly set.
///
/// The base size (`xSmall`) is used as the foundation, and any unspecified breakpoint
/// will inherit its value from the previous specified breakpoint. This creates a
/// cascading effect from smaller to larger screens.
public struct ResponsiveValues<Value>: Hashable, Equatable, Sendable
    where Value: Equatable & Hashable & Sendable {
    private let xSmall: Value?
    private let small: Value?
    private let medium: Value?
    private let large: Value?
    private let xLarge: Value?
    private let xxLarge: Value?

    /// Creates responsive values with an optional base size and larger breakpoint sizes.
    /// - Parameters:
    ///   - xSmall: The base size, used at the smallest breakpoint
    ///   - small: Size for the small breakpoint
    ///   - medium: Size for the medium breakpoint
    ///   - large: Size for the large breakpoint
    ///   - xLarge: Size for the extra large breakpoint
    ///   - xxLarge: Size for the extra extra large breakpoint
    init(
        _ xSmall: Value? = nil,
        small: Value? = nil,
        medium: Value? = nil,
        large: Value? = nil,
        xLarge: Value? = nil,
        xxLarge: Value? = nil
    ) {
        self.xSmall = xSmall
        self.small = small
        self.medium = medium
        self.large = large
        self.xLarge = xLarge
        self.xxLarge = xxLarge
    }

    /// The breakpoint values with cascading behavior applied from smaller to larger screens.
    var values: OrderedDictionary<Breakpoint, Value> {
        values(cascaded: true)
    }

    /// Returns a dictionary mapping breakpoints to their values.
    /// - Parameter cascaded: Whether to apply cascading behavior (values inherit from smaller breakpoints)
    /// - Returns: Dictionary with breakpoint keys and their corresponding values
    func values(cascaded: Bool) -> OrderedDictionary<Breakpoint, Value> {
        let breakpoints: OrderedDictionary<Breakpoint, Value?> = [
            .xSmall: xSmall,
            .small: small,
            .medium: medium,
            .large: large,
            .xLarge: xLarge,
            .xxLarge: xxLarge
        ]

        return if cascaded {
            resolve(breakpoints)
        } else {
            breakpoints.compactMapValues { $0 }
        }
    }

    /// Processes breakpoints with optional values and applies inheriting if enabled.
    /// - Parameter breakpoints: Ordered dictionary of breakpoints and their optional values
    /// - Returns: Dictionary mapping breakpoints to their effective values after cascading
    private func resolve(_ breakpoints: OrderedDictionary<Breakpoint, Value?>) -> OrderedDictionary<Breakpoint, Value> {
        breakpoints.reduce(into: (
            results: OrderedDictionary<Breakpoint, Value>(),
            lastValue: Value?(nil))
        ) { collected, pair in
            let (breakpoint, currentValue) = pair
            if let currentValue {
                collected.results[breakpoint] = currentValue
                collected.lastValue = currentValue
            } else if let lastValue = collected.lastValue {
                collected.results[breakpoint] = lastValue
            }
        }.results
    }
}

public extension Theme.ResponsiveValues {
    /// Creates responsive values with an optional base size and larger breakpoint sizes.
    /// - Parameters:
    ///   - xSmall: The base size, used at the smallest breakpoint
    ///   - small: Size for the small breakpoint
    ///   - medium: Size for the medium breakpoint
    ///   - large: Size for the large breakpoint
    ///   - xLarge: Size for the extra large breakpoint
    ///   - xxLarge: Size for the extra extra large breakpoint
    init(
        _ xSmall: LengthUnit? = nil,
        small: LengthUnit? = nil,
        medium: LengthUnit? = nil,
        large: LengthUnit? = nil,
        xLarge: LengthUnit? = nil,
        xxLarge: LengthUnit? = nil
    ) {
        self.xSmall = xSmall
        self.small = small
        self.medium = medium
        self.large = large
        self.xLarge = xLarge
        self.xxLarge = xxLarge
    }
}
