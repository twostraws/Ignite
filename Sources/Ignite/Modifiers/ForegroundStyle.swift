//
// ForegroundStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Common foreground styles that allow for clear readability.
public enum ForegroundStyle: String {
    case primary = "text-primary"
    case primaryEmphasis = "text-primary-emphasis"
    case secondary = "text-body-secondary"
    case tertiary = "text-body-tertiary"

    case success = "text-success"
    case successEmphasis = "text-success-emphasis"
    case danger = "text-danger"
    case dangerEmphasis = "text-danger-emphasis"
    case warning = "text-warning"
    case warningEmphasis = "text-warning-emphasis"
    case info = "text-info"
    case infoEmphasis = "text-info-emphasis"
    case light = "text-light"
    case lightEmphasis = "text-light-emphasis"
    case dark = "text-dark"
    case darkEmphasis = "text-dark-emphasis"
    case body = "text-body"
    case bodyEmphasis = "text-body-emphasis"
}

extension BlockElement {
    /// Applies a foreground style to the current element.
    /// - Parameter style: The style to apply, specified as a
    ///  `ForegroundStyle` case.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ style: ForegroundStyle) -> Self {
        self.class(style.rawValue)
    }

    /// Applies a foreground style to the current element.
    /// - Parameter style: The style to apply, specified as a `Color`.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ color: Color) -> Self {
        self.style("color: \(color)")
    }

    /// Applies a foreground style to the current element.
    /// - Parameter style: The style to apply, specified as a string.
    /// - Returns: The current element with the updated color applied.
    public func foregroundStyle(_ color: String) -> Self {
        self.style("color: \(color)")
    }
}
