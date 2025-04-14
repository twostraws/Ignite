//
// ControlSize.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// The size of form controls and labels
public enum ControlSize: Sendable, CaseIterable {
    case small
    case medium
    case large

    var controlClass: String? {
        switch self {
        case .small: "form-control-sm"
        case .large: "form-control-lg"
        case .medium: nil
        }
    }

    var labelClass: String? {
        switch self {
        case .small: "col-form-label-sm"
        case .large: "col-form-label-lg"
        case .medium: nil
        }
    }

    var buttonClass: String? {
        switch self {
        case .small: "btn-sm"
        case .large: "btn-lg"
        case .medium: nil
        }
    }
}
