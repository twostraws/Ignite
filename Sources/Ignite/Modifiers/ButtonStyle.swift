//
// ButtonStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that applies custom button styling to button elements.
struct ButtonStyleModifier: HTMLModifier {
    /// The style to apply to the button.
    var style: any Style

    /// The original role of the button.
    var originalRole: Role

    /// Applies the button style to the provided button content.
    /// - Parameter content: The button content to modify
    /// - Returns: The modified button with styling applied
    func body(content: some HTML) -> any HTML {
        if style is OutlineButtonStyle {
            // If no role was set, default to primary for outline style
            let effectiveRole = originalRole == .default ? .primary : originalRole
            content.class("btn-outline-\(effectiveRole.rawValue)")
        } else if let toggleStyle = style as? ToggleButtonStyle {
            content
                .data("bs-toggle", "button")
                .data("aria-pressed", toggleStyle.attributes["aria-pressed"] ?? "false")
                .class(toggleStyle.register())
        }
        content
    }
}

public extension Button {
    /// Applies a custom button style to this button.
    /// - Parameter style: The style to apply
    /// - Returns: A modified button with the style applied
    func buttonStyle(_ style: any Style) -> some HTML {
        // Create a copy of self with modified role if needed
        var button = self

        // Set role to default for outline styles to prevent double styling
        if style is OutlineButtonStyle {
            button.role = .default
        }

        return button.modifier(ButtonStyleModifier(
            style: style,
            originalRole: role)
        )
    }
}
