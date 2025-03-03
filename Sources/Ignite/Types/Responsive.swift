//
// PublishingContext-ResponsiveValues.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol for types that scale across responsive breakpoints
public protocol Responsive {
    /// The type of value being scaled
    associatedtype Value

    /// The base value for extra small screens (<576px)
    var xSmall: Value? { get }

    /// The value for small screens (≥576px)
    var small: Value { get }

    /// The value for medium screens (≥768px)
    var medium: Value { get }

    /// The value for large screens (≥992px)
    var large: Value { get }

    /// The value for extra large screens (≥1200px)
    var xLarge: Value { get }

    /// The value for extra extra large screens (≥1400px)
    var xxLarge: Value { get }

    /// The default values to use when no value is specified
    static var defaults: ResponsiveValues<Value> { get }

    /// Creates a new instance with resolved responsive values
    /// - Parameter values: The resolved values for each breakpoint
    init(values: ResponsiveValues<Value>)
}

/// A breakpoint value that may inherit from previous breakpoints
private struct UnresolvedBreakpoint<Value> {
    /// The breakpoint this value applies to
    var breakpoint: Breakpoint

    /// The optional value for this breakpoint
    var value: Value?

    /// The default value if no value is specified or inherited
    var `default`: Value

    /// Creates a new unresolved breakpoint value
    /// - Parameters:
    ///   - breakpoint: The breakpoint this value applies to
    ///   - value: The optional value for this breakpoint
    ///   - default: The default value if no value is specified or inherited
    init(_ breakpoint: Breakpoint, value: Value?, default: Value) {
        self.breakpoint = breakpoint
        self.value = value
        self.default = `default`
    }
}

extension Responsive {
    /// Resolves breakpoint values, handling inheritance between breakpoints
    /// - Parameters:
    ///   - values: Array of unresolved breakpoint values
    ///   - initialLastValue: Optional initial value to inherit from
    /// - Returns: Resolved values for each breakpoint
    private static func resolve(
        _ values: [UnresolvedBreakpoint<Value>],
        initialLastValue: Value? = nil
    ) -> ResponsiveValues<Value> {
        let resolvedPairs = values.reduce(into: (
            results: [(Breakpoint, Value)](),
            lastValue: initialLastValue
        )) { collected, current in
            if let currentValue = current.value {
                // Use specified value and update inheritance
                collected.results.append((current.breakpoint, currentValue))
                collected.lastValue = current.value
            } else if let lastValue = collected.lastValue {
                // Inherit from previous breakpoint
                collected.results.append((current.breakpoint, lastValue))
            } else {
                // Fall back to default value
                collected.results.append((current.breakpoint, current.default))
            }
        }.results

        // Create lookup dictionary for resolved values
        var resolved: [Breakpoint: Value] = [:]
        for (breakpoint, value) in resolvedPairs {
            resolved[breakpoint] = value
        }

        return ResponsiveValues(
            xSmall: initialLastValue,
            small: resolved[.small]!,
            medium: resolved[.medium]!,
            large: resolved[.large]!,
            xLarge: resolved[.xLarge]!,
            xxLarge: resolved[.xxLarge]!
        )
    }

    /// Creates a new instance with responsive values that inherit between breakpoints
    /// - Parameters:
    ///   - xSmall: Base value for extra small screens. Pass `nil` to inherit from small.
    ///   - small: Value for small screens. Pass `nil` to use default.
    ///   - medium: Value for medium screens. Pass `nil` to inherit from previous breakpoint.
    ///   - large: Value for large screens. Pass `nil` to inherit from previous breakpoint.
    ///   - xLarge: Value for extra large screens. Pass `nil` to inherit from previous breakpoint.
    ///   - xxLarge: Value for extra extra large screens. Pass `nil` to inherit from previous breakpoint.
    public init(
        xSmall: Value? = nil,
        small: Value? = nil,
        medium: Value? = nil,
        large: Value? = nil,
        xLarge: Value? = nil,
        xxLarge: Value? = nil
    ) {
        let unresolvedValues: [UnresolvedBreakpoint] = [
            .init(.small, value: small, default: Self.defaults.small),
            .init(.medium, value: medium, default: Self.defaults.medium),
            .init(.large, value: large, default: Self.defaults.large),
            .init(.xLarge, value: xLarge, default: Self.defaults.xLarge),
            .init(.xxLarge, value: xxLarge, default: Self.defaults.xxLarge)
        ]

        let resolvedValues = Self.resolve(unresolvedValues, initialLastValue: xSmall)
        self.init(values: resolvedValues)
    }
}
