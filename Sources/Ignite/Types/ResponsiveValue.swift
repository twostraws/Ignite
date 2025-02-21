//
// ResponsiveValue.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Protocol for types that can be represented as Bootstrap classes
public protocol Responsive {
    /// Returns the Bootstrap class representation of this value
    /// - Parameter breakpoint: Optional breakpoint identifier (e.g., "md", "lg")
    /// - Returns: A Bootstrap class name for this value at the given breakpoint
    func responsiveClass(for breakpoint: String?) -> String
}

/// Defines how a value changes across different screen sizes.
///
/// Use `ResponsiveValue` to specify responsive behavior at different breakpoints:
/// ```swift
/// Text("Hello")
///     // Font size changes at different breakpoints
///     .font(.system(size: .responsive(small: 12, medium: 14, large: 16)))
///
///     // Padding adjusts responsively
///     .padding(.responsive(small: 4, medium: 6, large: 10)))
/// ```
public struct ResponsiveValue<Value>: Hashable, Equatable, Sendable where Value: Equatable & Hashable & Sendable {
    private let small: Value?
    private let medium: Value?
    private let large: Value?
    private let xLarge: Value?
    private let xxLarge: Value?

    /// Applies breakpoint-specific values
    public static func responsive(
        small: Value? = nil,
        medium: Value? = nil,
        large: Value? = nil,
        xLarge: Value? = nil,
        xxLarge: Value? = nil
    ) -> Self {
        Self(small: small, medium: medium, large: large, xLarge: xLarge, xxLarge: xxLarge)
    }

    private init(
        small: Value? = nil,
        medium: Value? = nil,
        large: Value? = nil,
        xLarge: Value? = nil,
        xxLarge: Value? = nil
    ) {
        self.small = small
        self.medium = medium
        self.large = large
        self.xLarge = xLarge
        self.xxLarge = xxLarge
    }

    /// Returns an ordered array of breakpoint-value pairs,
    /// from smallest to largest screen size.
    var breakpointValues: [(breakpoint: String?, value: Value)] {
        var results: [(String?, Value)] = []

        if let small {
            results.append((nil, small))
        }
        if let medium {
            results.append(("md", medium))
        }
        if let large {
            results.append(("lg", large))
        }
        if let xLarge {
            results.append(("xl", xLarge))
        }
        if let xxLarge {
            results.append(("xxl", xxLarge))
        }

        return results
    }
}

extension ResponsiveValue where Value: Responsive {
    /// The corresponding Bootstrap classes for this responsive value
    var breakpointClasses: String {
        breakpointValues.map { breakpoint, value in
            value.responsiveClass(for: breakpoint)
        }.joined(separator: " ")
    }
}

/// Defines horizontal alignment behavior across different screen sizes
public typealias ResponsiveAlignment = ResponsiveValue<HorizontalAlignment>

/// Defines font size behavior across different screen sizes
public typealias ResponsiveFontSize = ResponsiveValue<LengthUnit>
