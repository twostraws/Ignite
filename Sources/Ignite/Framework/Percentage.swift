//
// Percentage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines the postfix operator for percentages
postfix operator %

/// A percentage value that can be any positive or negative number.
///
/// ```swift
/// let scale: Percentage = 150%
/// let reduction: Percentage = -25%
/// ```
public struct Percentage: Hashable {
    /// The type used for storing the raw percentage value, allowing for decimal points
    public typealias Value = Double

    /// The type used for storing rounded percentage values as whole numbers
    public typealias RoundedValue = Int

    /// The raw percentage value, can be positive or negative and include decimal points
    public var value: Value

    /// Creates a new percentage with the specified value
    /// - Parameter value: The percentage value to store (e.g. 42.5 for 42.5%)
    public init(_ value: Value) {
        self.value = value
    }

    /// Returns the percentage as a whole number, rounded to the nearest integer
    public var roundedValue: RoundedValue {
        RoundedValue(round(value))
    }

    /// Returns the percentage value with a specified number of decimal places
    /// - Parameter decimals: The number of decimal places to include (default: 1)
    /// - Returns: The formatted percentage value
    public func value(decimals: Int = 1) -> Double {
        let multiplier = pow(10.0, Double(decimals))
        return round(value * multiplier) / multiplier
    }
}

public extension Percentage {
    static func - (lhs: Percentage, rhs: Percentage) -> Double {
        return lhs.value - rhs.value
    }

    static func + (lhs: Percentage, rhs: Percentage) -> Double {
        return lhs.value + rhs.value
    }

    static func * (lhs: Double, rhs: Percentage) -> Double {
        return lhs * (rhs.value / 100.0)
    }

    static func * (lhs: Percentage, rhs: Double) -> Double {
        return (lhs.value / 100.0) * rhs
    }
}

/// Creates a `Percentage` from a `Double`
public postfix func % (value: Double) -> Percentage {
    return Percentage(value)
}

/// Creates a `Percentage` from an `Int`
public postfix func % (value: Int) -> Percentage {
    return Percentage(Double(value))
}

extension Percentage: Comparable {
    public static func < (lhs: Percentage, rhs: Percentage) -> Bool {
        return lhs.value < rhs.value
    }
}

extension BinaryFloatingPoint {
    /// Returns a string representation with the percentage symbol
    /// - Returns: Formatted string with percentage symbol
    func asString() -> String where Self == Percentage.Value {
        return "\(self)%"
    }
}

extension BinaryInteger {
    /// Returns a string representation with the percentage symbol
    /// - Returns: Formatted string with percentage symbol
    func asString() -> String where Self == Percentage.RoundedValue {
        return "\(self)%"
    }
}
