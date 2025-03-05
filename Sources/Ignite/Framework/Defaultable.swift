//
// Nullable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines a type that can represent a "none" state without being optional
protocol Defaultable {
    /// Whether this value represents a default value
    var isDefault: Bool { get }
}

extension Font: Defaultable {
    /// The empty font instance used as a default value
    static var `default`: Font { Font(name: "", sources: []) }

    /// Indicates whether this font is the default (empty) font
    var isDefault: Bool { self == .default }
}

extension Color: Defaultable {
    /// The empty color instance used as a default value
    static var `default`: Color { Color(hex: "") }

    /// Indicates whether this color is the default (empty) color
    var isDefault: Bool { self == .default }
}

extension HighlighterTheme: Defaultable {
    /// Indicates whether this theme is the default (none) theme
    var isDefault: Bool { self == .none }
}

extension TextDecoration: Defaultable {
    /// Indicates whether this decoration is the default (underline) decoration
    var isDefault: Bool { self == .underline }
}

extension ResponsiveValues: Defaultable where Value == LengthUnit {
    /// Indicates whether these values are the default (empty)
    var isDefault: Bool { self == .default }

    /// The empty values instance used as a default value
    static var `default`: Self {
        .init(
            small: nil,
            medium: nil,
            large: nil,
            xLarge: nil,
            xxLarge: nil
        )
    }
}
