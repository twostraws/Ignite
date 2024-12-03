//
// ToggleButtonStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Style for toggle buttons that can be switched between active and inactive states.
///
/// This style creates buttons that maintain their state (pressed/unpressed) when clicked.
/// It's useful for binary choices or showing active/inactive states.
public struct ToggleButtonStyle: Style {
    public static var prefix: String? { nil }
    public static var id: String { "ToggleButtonStyle" }

    /// The CSS class names to apply to the button
    public let className: String

    /// Additional HTML attributes required for toggle functionality
    let attributes: [String: String]

    /// Creates a new toggle button style
    /// - Parameters:
    ///   - role: The semantic role/variant of the button (default, primary, etc.)
    ///   - condition: The initial state of the toggle ("true" or "false")
    init(role: Role = .default, condition: String) {
        var classes = ["btn"]
        if role != .default {
            classes.append("btn-\(role.rawValue)")
        }

        self.className = classes.joined(separator: " ")
        self.attributes = [
            "data-bs-toggle": "button",
            "aria-pressed": condition
        ]
    }

    public var body: some Style {
        SystemStyle(className)
    }
}

/// Factory methods for creating toggle button styles
public extension Style where Self == ToggleButtonStyle {
    /// Creates a toggle button style
    /// - Parameters:
    ///   - role: The semantic role/variant of the button
    ///   - condition: The initial state of the toggle ("true" or "false")
    static func toggle(_ role: Role = .default, condition: String) -> Self {
        .init(role: role, condition: condition)
    }
}
