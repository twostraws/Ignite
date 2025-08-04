//
// ButtonType.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Whether this button is just clickable, or whether its submits a form.
public enum ButtonType: Sendable, CaseIterable {
    /// This button does not submit a form.
    case plain

    /// This button submits a form.
    case submit

    /// The HTML type attribute for this button.
    var htmlName: String {
        switch self {
        case .plain: "button"
        case .submit: "submit"
        }
    }
}
