//
// TextDecoration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Property sets the appearance of decorative lines on text.
public enum TextDecoration: String {
    case none
    case through
    case underline
}

extension HoverEffect {
    /// Applies a text decoration style to the current element.
    /// - Parameter style: The style to apply, specified as a `TextDecoration` case.
    /// - Returns: The current element with the updated text decoration style applied.
    public func textDecoration(_ style: TextDecoration) -> Self {
        switch style {
        case .none:
            self.style("text-decoration: none")
        case .through:
            self.style("text-decoration: line-through")
        case .underline:
            self.style("text-decoration: underline")
        }
    }
}
