//
// ControlLabelStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Controls how form labels are displayed
public enum ControlLabelStyle: CaseIterable, Sendable {
    /// Labels appear above their fields
    case top
    /// Labels appear to the left of their fields
    case leading
    /// Labels float when the field has content
    case floating
    /// No labels are shown
    case hidden
}
