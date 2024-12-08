//
// OutlineButtonStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Style for outline buttons that provides a bordered appearance with transparent background.
///
/// This style creates buttons that emphasize their borders rather than having a solid fill color.
/// It's commonly used for secondary actions or to create visual hierarchy.
public struct OutlineButtonStyle: Style {
    public static var prefix: String? { nil }
    public static var id: String { "OutlineButtonStyle" }

    /// The CSS class names to apply to the button
    public let className: String

    /// Creates a new outline button style
    /// - Parameter role: The semantic role/variant of the button (default, primary, etc.)
    public init(role: Role = .default) {
        var classes = ["btn"]
        if role != .default {
            classes.append("btn-outline-\(role.rawValue)")
        }
        self.className = classes.joined(separator: " ")
    }

    public var body: some Style {
        SystemStyle(className)
    }
}

/// Factory methods for creating button styles
public extension Style where Self == OutlineButtonStyle {
    /// Creates a default outline button style
    static var outline: Self { .init() }

    /// Creates an outline button style with the specified role
    /// - Parameter role: The semantic role/variant of the button
    static func outline(_ role: Role) -> Self { .init(role: role) }
}
