//
// Nullable.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A protocol that defines a type that can represent a "none" state without being optional
public protocol Defaultable {
    /// Whether this value represents a default value
    var isDefault: Bool { get }
}

extension Font: Defaultable {
    /// The empty font instance used as a default value
    public static var `default`: Font { Font(name: "", sources: []) }

    /// Indicates whether this font is the default (empty) font
    public var isDefault: Bool { self == .default }
}

extension Color: Defaultable {
    /// The empty color instance used as a default value
    public static var `default`: Color { Color(hex: "") }

    /// Indicates whether this color is the default (empty) color
    public var isDefault: Bool { self == .default }
}

extension HighlighterTheme: Defaultable {
    /// Indicates whether this theme is the default (none) theme
    public var isDefault: Bool { self == .none }
}

extension TextDecoration: Defaultable {
    /// Indicates whether this decoration is the default (underline) decoration
    public var isDefault: Bool { self == .underline }
}
