//
// DropdownConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// How the dropdown should be rendered based on its context.
enum DropdownConfiguration: Sendable, CaseIterable {
    /// Renders as a complete standalone dropdown.
    case standalone
    /// Renders for placement inside a navigation bar.
    case navigationBarItem
    /// Renders for placement inside a control group.
    case controlGroupItem
    /// Renders as the last item in a control group with special positioning.
    case lastControlGroupItem
}
