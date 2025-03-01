//
// ResponsiveValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public enum Responsive {
    /// Defines how a value changes across different screen sizes, allowing for partial specification of breakpoints.
    ///
    /// Use `PartialValues` to specify responsive behavior at selected breakpoints, with values cascading to larger
    /// breakpoints when not explicitly defined:
    ///
    /// ```swift
    /// Text("Hello")
    ///     // Font size defined at small and large breakpoints, with medium inheriting from small
    ///     .font(.system(size: .responsive(small: 12, large: 16)))
    ///
    ///     // Padding specified only at certain breakpoints
    ///     .padding(.responsive(small: 4, medium: 6, large: 10)))
    /// ```
    ///
    /// Values cascade upward from smaller to larger breakpoints, so any unspecified breakpoint will use
    /// the value from the largest specified smaller breakpoint.
    public struct PartialValues<Value>: Hashable, Equatable, Sendable where Value: Equatable & Hashable & Sendable {
        private let xSmall: Value?
        private let small: Value?
        private let medium: Value?
        private let large: Value?
        private let xLarge: Value?
        private let xxLarge: Value?

        /// Applies breakpoint-specific values
        public static func responsive(
            xSmall: Value? = nil,
            small: Value? = nil,
            medium: Value? = nil,
            large: Value? = nil,
            xLarge: Value? = nil,
            xxLarge: Value? = nil
        ) -> Self {
            Self(
                xSmall: xSmall,
                small: small,
                medium: medium,
                large: large,
                xLarge: xLarge,
                xxLarge: xxLarge
            )
        }

        private init(
            xSmall: Value? = nil,
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

        /// Returns an ordered array of breakpoint-value pairs,
        /// from smallest to largest screen size, with cascading applied if enabled.
        var values: [(breakpoint: Breakpoint, value: Value)] {
            // Create a sequence of breakpoint names and their corresponding values
            let breakpoints: [(Breakpoint, Value?)] = [
                (.xSmall, xSmall),
                (.small, small),
                (.medium, medium),
                (.large, large),
                (.xLarge, xLarge),
                (.xxLarge, xxLarge)
            ]

            return resolve(breakpoints)
        }

        /// Processes breakpoints with optional values and applies inheriting if enabled.
        /// - Parameter breakpoints: Array of tuples containing breakpoint identifiers and their optional values
        /// - Returns: Array of tuples with breakpoint identifiers and their effective values after cascading
        private func resolve(_ breakpoints: [(Breakpoint, Value?)]) -> [(Breakpoint, Value)] {
            breakpoints.reduce(into: (
                results: [(Breakpoint, Value)](),
                lastValue: Value?(nil))
            ) { collected, current in
                let (breakpoint, currentValue) = current
                if let currentValue {
                    collected.results.append((breakpoint, currentValue))
                    collected.lastValue = currentValue
                } else if let lastValue = collected.lastValue {
                    collected.results.append((breakpoint, lastValue))
                }
            }.results
        }
    }
}

/// Defines horizontal alignment behavior across different screen sizes
public typealias ResponsiveAlignment = Responsive.PartialValues<HorizontalAlignment>

/// Defines font size behavior across different screen sizes
public typealias ResponsiveFontSize = Responsive.PartialValues<LengthUnit>
