//
// AccessibilityLabel.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension Element {
    /// Adds a label to an arbitrary element. Specific types override this in places
    /// where accessibility labels need exact forms, e.g. alt text for images.
    func accessibilityLabel(_ label: String) -> some Element {
        self.aria(.label, label)
    }
}
