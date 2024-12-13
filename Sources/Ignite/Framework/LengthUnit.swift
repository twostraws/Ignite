//
// Unit.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol representing a CSS unit of measurement or value
public protocol LengthUnit: CustomStringConvertible, Equatable, Hashable, Sendable {
    var stringValue: String { get }
}

extension LengthUnit {
    public var stringValue: String {
        if let intValue = self as? Int, intValue == .viewport {
            return "100vw"
        }

        if let intValue = self as? Int {
            return "\(intValue)px"
        }

        return String(describing: self)
    }
}

public extension LengthUnit where Self == Int {
    /// Returns a special value indicating that a dimension should use 100% of the viewport size
    static var viewport: Int { .max }
}

public extension LengthUnit where Self == Double {
    /// Returns a special value indicating that a dimension should use 100% of the parent container
    static var infinity: Double { Double.infinity }
}

/// Enables `String` to represent CSS unit values
extension String: LengthUnit {}

/// Enables `Int` to represent numeric CSS values
extension Int: LengthUnit {}

/// Enables `Double` to represent numeric CSS values
extension Double: LengthUnit {}
