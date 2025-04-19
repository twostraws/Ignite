//
// TextDecoration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Property sets the appearance of decorative lines on text.
public enum TextDecoration: String, CaseIterable, Sendable {
    case none
    case through = "line-through"
    case underline
}

public extension HTML {
    /// Applies a text decoration style to the current element.
    /// - Parameter style: The style to apply, specified as a `TextDecoration` case.
    /// - Returns: The current element with the updated text decoration style applied.
    func textDecoration(_ style: TextDecoration) -> some HTML {
        self.style(.textDecoration, style.rawValue)
    }
}

public extension StyledHTML {
    /// Applies a text decoration style to the current element.
    /// - Parameter style: The style to apply, specified as a `TextDecoration` case.
    /// - Returns: The current element with the updated text decoration style applied.
    func textDecoration(_ style: TextDecoration) -> Self {
        self.style(.textDecoration, style.rawValue)
    }
}
