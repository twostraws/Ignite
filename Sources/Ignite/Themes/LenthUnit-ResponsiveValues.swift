//
// ResponsiveBreakpoint.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A structure that manages responsive values across different breakpoints.
///
/// Use `ResponsiveValues` to define different length values for various screen sizes,
/// with support for cascading values across breakpoints. For example:
///
/// ```swift
/// let padding = ResponsiveValues(
///     small: .px(10),
///     medium: .px(20),
///     large: .px(30)
/// )
/// ```
public extension LengthUnit {
    struct ResponsiveValues: Hashable, Sendable {
        /// The length value for extra small screens.
        var xSmall: LengthUnit = .default

        /// The length value for small screens.
        var small: LengthUnit = .default

        /// The length value for medium screens.
        var medium: LengthUnit = .default

        /// The length value for large screens.
        var large: LengthUnit = .default

        /// The length value for extra large screens.
        var xLarge: LengthUnit = .default

        /// The length value for extra extra large screens.
        var xxLarge: LengthUnit = .default

        /// Determines whether values cascade upward through breakpoints.
        private let cascadeUpward: Bool

        /// Creates a new responsive values configuration.
        /// - Parameters:
        ///   - xSmall: The value for extra small screens.
        ///   - small: The value for small screens.
        ///   - medium: The value for medium screens.
        ///   - large: The value for large screens.
        ///   - xLarge: The value for extra large screens.
        ///   - xxLarge: The value for extra extra large screens.
        ///   - cascade: Whether values should cascade upward through breakpoints.
        public init(
            xSmall: LengthUnit? = nil,
            small: LengthUnit? = nil,
            medium: LengthUnit? = nil,
            large: LengthUnit? = nil,
            xLarge: LengthUnit? = nil,
            xxLarge: LengthUnit? = nil,
            cascade: Bool = true
        ) {
            self.cascadeUpward = cascade

            let breakpointValues: [(breakpoint: Breakpoint, value: LengthUnit?)] = [
                (.xSmall, xSmall),
                (.small, small),
                (.medium, medium),
                (.large, large),
                (.xLarge, xLarge),
                (.xxLarge, xxLarge)
            ]

            let resolvedValues = self.resolve(breakpointValues)

            for value in resolvedValues {
                switch value.breakpoint {
                case .xSmall: self.xSmall = value.value
                case .small: self.small = value.value
                case .medium: self.medium = value.value
                case .large: self.large = value.value
                case .xLarge: self.xLarge = value.value
                case .xxLarge: self.xxLarge = value.value
                }
            }
        }

        /// Processes breakpoint values to handle cascading behavior.
        /// - Parameter breakpointValues: The array of breakpoint values to process.
        /// - Returns: An array of processed breakpoint values with cascading applied.
        private func resolve(
            _ values: [(breakpoint: Breakpoint, value: LengthUnit?)]
        ) -> [(breakpoint: Breakpoint, value: LengthUnit)] {
            values.reduce(into: (
                results: [(Breakpoint, LengthUnit)](),
                lastValue: nil as LengthUnit?)
            ) { collected, current in
                let (breakpoint, currentValue) = current
                if let currentValue {
                    collected.results.append((breakpoint, currentValue))
                    collected.lastValue = currentValue
                } else if cascadeUpward, let lastValue = collected.lastValue {
                    collected.results.append((breakpoint, lastValue))
                } else {
                    collected.results.append((breakpoint, breakpoint.defaultWidth))
                }
            }.results
        }
    }
}
