//
// Unit.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol representing a CSS unit of measurement or value
public protocol LengthUnit: CustomStringConvertible, Equatable, Hashable, Defaultable, Sendable {
    /// The string representation of this unit's value
    var stringValue: String { get }

    /// Indicates whether this unit represents a default value
    var isDefault: Bool { get }
}

extension LengthUnit {
    public var isDefault: Bool {
        (self as? Int) == .min
    }

    public var stringValue: String {
        guard let intValue = self as? Int else {
            return String(describing: self)
        }

        switch intValue {
        case .viewport: return "100vw"
        default: return "\(intValue)px"
        }
    }
}

public extension LengthUnit where Self == Int {
    /// A special value indicating that a dimension should use 100% of the viewport width
    static var viewport: Int { .max }

    /// The default value for length units, represented by the minimum integer value
    static var `default`: Int { .min }
}

/// Enables `String` to represent CSS unit values
extension String: LengthUnit {}

/// Enables `Int` to represent numeric CSS values
extension Int: LengthUnit {}

/// Enables `Double` to represent numeric CSS values
extension Double: LengthUnit {}
