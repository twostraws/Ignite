//
// BooleanAttributeModifiers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

public extension HTML {
    /// Disables the element, preventing user interaction.
    /// - Parameter isDisabled: Whether the element should be disabled. Default is `true`.
    /// - Returns: A modified copy of the element with the `disabled` attribute applied.
    func disabled(_ isDisabled: Bool = true) -> some HTML {
        booleanAttribute("disabled", isEnabled: isDisabled)
    }

    /// Marks the element as required.
    /// - Parameter isRequired: Whether the element is required. Default is `true`.
    /// - Returns: A modified copy of the element with the `required` attribute applied.
    func required(_ isRequired: Bool = true) -> some HTML {
        booleanAttribute("required", isEnabled: isRequired)
    }
}
