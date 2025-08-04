//
// FormConfiguration.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Configuration options for customizing a form's layout and appearance.
struct FormConfiguration: Sendable {
    /// The number of columns in the form's grid layout.
    var columnCount: Int = 12

    /// The amount of space between form elements.
    var spacing: SemanticSpacing = .medium

    /// The display style for form control labels.
    var labelStyle: ControlLabelStyle = .floating

    /// The size of controls within the form.
    var controlSize: ControlSize = .medium
}
