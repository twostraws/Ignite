//
// ResponsiveValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Protocol for types that can be represented as Bootstrap classes
protocol Responsive {
    /// Returns the Bootstrap class representation of this value
    /// - Parameter breakpoint: Optional breakpoint identifier (e.g., "md", "lg")
    /// - Returns: A Bootstrap class name for this value at the given breakpoint
    func responsiveClass(for breakpoint: Breakpoint) -> String
}

/// Defines how a value changes across different screen sizes.
///
/// Use `ResponsiveValues` to specify responsive behavior at different breakpoints:
/// ```swift
/// Text("Hello")
///     // Font size changes at different breakpoints
///     .font(.system(size: .responsive(small: 12, medium: 14, large: 16)))
///
///     // Padding adjusts responsively
///     .padding(.responsive(small: 4, medium: 6, large: 10)))
/// ```
public struct ResponsiveValues<Value>: Hashable, Equatable, Sendable where Value: Equatable & Hashable & Sendable {
    private let xSmall: Value?
    private let small: Value?
    private let medium: Value?
    private let large: Value?
    private let xLarge: Value?
    private let xxLarge: Value?
    private let cascadeUpward: Bool

    /// Applies breakpoint-specific values
    public static func responsive(
        xSmall: Value? = nil,
        small: Value? = nil,
        medium: Value? = nil,
        large: Value? = nil,
        xLarge: Value? = nil,
        xxLarge: Value? = nil,
        cascade: Bool = true
    ) -> Self {
        Self(small: small, medium: medium, large: large, xLarge: xLarge, xxLarge: xxLarge)
    }

    private init(
        xSmall: Value? = nil,
        small: Value? = nil,
        medium: Value? = nil,
        large: Value? = nil,
        xLarge: Value? = nil,
        xxLarge: Value? = nil,
        cascade: Bool = true
    ) {
        self.xSmall = xSmall
        self.small = small
        self.medium = medium
        self.large = large
        self.xLarge = xLarge
        self.xxLarge = xxLarge
        self.cascadeUpward = cascade
    }

    /// Returns an ordered array of breakpoint-value pairs,
    /// from smallest to largest screen size, with cascading applied if enabled.
    var breakpointValues: [(breakpoint: Breakpoint, value: Value)] {
        // Create a sequence of breakpoint names and their corresponding values
        let breakpoints: [(Breakpoint, Value?)] = [
            (.xSmall, xSmall),
            (.small, small),
            (.medium, medium),
            (.large, large),
            (.xLarge, xLarge),
            (.xxLarge, xxLarge)
        ]

        return cascade(breakpoints)
    }

    /// Processes breakpoints with optional values and applies cascading if enabled.
    /// - Parameters:
    ///   - breakpoints: Array of tuples containing breakpoint identifiers and their optional values
    ///   - cascade: Whether to cascade values from smaller to larger breakpoints
    /// - Returns: Array of tuples with breakpoint identifiers and their effective values after cascading
    private func cascade(_ breakpoints: [(Breakpoint, Value?)]) -> [(Breakpoint, Value)] {
        breakpoints.reduce(into: (
            results: [(Breakpoint, Value)](),
            lastValue: Value?(nil))
        ) { collected, current in
            let (breakpoint, currentValue) = current
            if let currentValue {
                collected.results.append((breakpoint, currentValue))
                collected.lastValue = currentValue
            } else if cascadeUpward, let lastValue = collected.lastValue {
                collected.results.append((breakpoint, lastValue))
            } else {
                // Use default
            }
        }.results
    }
}

extension ResponsiveValues where Value: Responsive {
    /// The corresponding Bootstrap classes for this responsive value
    var breakpointClasses: String {
        breakpointValues.map { breakpoint, value in
            value.responsiveClass(for: breakpoint)
        }.joined(separator: " ")
    }
}

/// Defines horizontal alignment behavior across different screen sizes
public typealias ResponsiveAlignment = ResponsiveValues<HorizontalAlignment>

/// Defines font size behavior across different screen sizes
public typealias ResponsiveFontSize = ResponsiveValues<LengthUnit>
