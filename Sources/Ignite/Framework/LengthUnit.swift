//
// LengthUnit.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

// swiftlint:disable identifier_name
/// Represents a CSS length value with its unit of measurement
public enum LengthUnit: Hashable, Equatable, Sendable, CustomStringConvertible, Defaultable {
    /// Pixels
    case px(Int)
    /// Relative to root element font size
    case rem(Double)
    /// Relative to parent element font size
    case em(Double)
    /// Relative to the parent element
    case percent(Percentage)
    /// Relative to 1% of the viewport width
    case vw(Percentage)
    /// Relative to 1% of the viewport height
    case vh(Percentage)
    /// A custom unit like min(60vw, 300px)
    case custom(String)

    public var description: String {
        switch self {
        case .px(let value): "\(value)px"
        case .rem(let value): "\(value)rem"
        case .em(let value): "\(value)em"
        case .percent(let percentage): "\(percentage.value)%"
        case .vw(let percentage): "\(percentage.value)vw"
        case .vh(let percentage): "\(percentage.value)vh"
        case .custom(let value): value
        }
    }

    /// The string representation of this unit's value
    public var stringValue: String { description }

    /// Special value indicating default
    static var `default`: LengthUnit { .em(.infinity) }

    /// Indicates whether this unit represents a default value
    var isDefault: Bool {
        if self == .default { return true }
        return false
    }
}
// swiftlint:enable identifier_name
