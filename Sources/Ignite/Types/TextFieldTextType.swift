//
// TextFieldTextType.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The type of text field
public enum TextFieldTextType: String, CaseIterable, Sendable {
    /// Standard text input
    case text
    /// Email address input
    case email
    /// Password input
    case password
    /// Search input
    case search
    /// URL input
    case url
    /// Phone number input
    case phone
    /// Numeric input
    case number
}
