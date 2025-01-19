//
// BooleanAttributeModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A modifier that adds a boolean attribute to an element.
struct BooleanAttributeModifier: HTMLModifier {
    /// The name of the attribute.
    var name: String
    /// Whether the attribute is enabled or disabled.
    var isEnabled: Bool

    /// Adds the `disabled` boolean attribute to the element.
    func body(content: some HTML) -> any HTML {
        content.customAttribute(name: name, isEnabled: isEnabled)
    }
}

public extension HTML {
    /// Disables the element, preventing user interaction.
    /// - Parameter isDisabled: Whether the element should be disabled. Default is `true`.
    /// - Returns: A modified copy of the element with the `disabled` attribute applied
    func disabled(_ isDisabled: Bool = true) -> some HTML {
        modifier(BooleanAttributeModifier(name: "disabled", isEnabled: isDisabled))
    }

    /// Marks the element as required.
    /// - Parameter isRequired: Whether the element is required. Default is `true`.
    /// - Returns: A modified copy of the element with the `required` attribute applied.
    func required(_ isRequired: Bool = true) -> some HTML {
        modifier(BooleanAttributeModifier(name: "required", isEnabled: isRequired))
    }
}
