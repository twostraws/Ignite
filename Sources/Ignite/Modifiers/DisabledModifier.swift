//
// DisabledModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Ignite

/// A modifier that disables an element, preventing user interaction.
struct DisabledModifier: HTMLModifier {
    /// Whether the element should be disabled
    var isDisabled: Bool

    /// Adds the `disabled` boolean attribute to the element.
    func body(content: some HTML) -> any HTML {
        content.booleanAttribute("disabled", isEnabled: isDisabled)
    }
}

public extension HTML {
    /// Disables the element, preventing user interaction.
    /// - Parameter isDisabled: Whether the element should be disabled. Default is `true`.
    /// - Returns: A modified copy of the element with the `disabled` attribute applied
    func disabled(_ isDisabled: Bool = true) -> some HTML {
        modifier(DisabledModifier(isDisabled: isDisabled))
    }
}
