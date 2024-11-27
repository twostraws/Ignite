//
// AccessibilityLabel.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

struct AccessibilityLabelModifier: HTMLModifier {
    var label: String

    func body(content: some HTML) -> any HTML {
        content.aria("label", label)
    }
}

public extension HTML {
    /// Adds a label to an arbitrary element. Specific types override this in places
    /// where accessibility labels need exact forms, e.g. alt text for images.
    func accessibilityLabel(_ label: String) -> some HTML {
        modifier(AccessibilityLabelModifier(label: label))
    }
}
