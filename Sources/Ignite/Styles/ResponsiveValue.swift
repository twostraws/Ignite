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
///     .font(.system(size: .small(12), .medium(14), .large(16)))
///
///     // Padding adjusts responsively
///     .padding(.small(8), .medium(16), .large(24))
/// ```
public enum ResponsiveValue<Value>: Hashable, Equatable, Sendable where Value: Equatable & Hashable & Sendable {
    /// Applies value at the small breakpoint
    case small(Value)

    /// Applies value at the medium breakpoint
    case medium(Value)

    /// Applies value at the large breakpoint
    case large(Value)

    /// Applies value at the extra large breakpoint
    case xLarge(Value)

    /// Applies value at the extra extra large breakpoint
    case xxLarge(Value)

    /// Returns the breakpoint and value for this responsive value
    var resolved: (breakpoint: String?, value: Value) {
        switch self {
        case .small(let value): (nil, value)
        case .medium(let value): ("md", value)
        case .large(let value): ("lg", value)
        case .xLarge(let value): ("xl", value)
        case .xxLarge(let value): ("xxl", value)
        }
    }
}

extension ResponsiveValue where Value: Responsive {
    /// The corresponding Bootstrap class for this responsive value
    var breakpointClass: String {
        let (breakpoint, value) = resolved
        return value.responsiveClass(for: breakpoint)
    }
}

/// Defines horizontal alignment behavior across different screen sizes
public typealias ResponsiveAlignment = ResponsiveValue<HorizontalAlignment>

/// Defines font size behavior across different screen sizes
public typealias ResponsiveFontSize = ResponsiveValue<LengthUnit>
