//
// LengthUnit.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Represents a CSS length value with its unit of measurement
public enum LengthUnit: Hashable, Equatable, Sendable, CustomStringConvertible, Defaultable {
    /// Pixels (px)
    case px(Double)
    /// Relative to root element font size (rem)
    case rem(Double)
    /// Relative to parent element font size (em)
    case em(Double)
    /// Percentage (%)
    case percent(Double)
    /// Viewport width unit (vw)
    case vw(Double)
    /// Viewport height unit (vh)
    case vh(Double)
    /// Special value indicating container width
    case container

    public var description: String {
        switch self {
        case .px(let value): "\(value)px"
        case .rem(let value): "\(value)rem"
        case .em(let value): "\(value)em"
        case .percent(let value): "\(value)%"
        case .vw(let value): "\(value)vw"
        case .vh(let value): "\(value)vh"
        case .container: "100%"
        }
    }

    /// The string representation of this unit's value
    public var stringValue: String { description }

    /// Special value indicating default
    static var `default`: LengthUnit { .px(.infinity) }

    /// Indicates whether this unit represents a default value
    public var isDefault: Bool {
        if self == .default { return true }
        return false
    }
}
