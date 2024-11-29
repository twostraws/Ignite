//
// BorderStyle.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Defines the style of a border.
public enum BorderStyle: String {
    /// Specifies no border
    case none
    /// A series of dots
    case dotted
    /// A series of dashes
    case dashed
    /// A single solid line
    case solid
    /// Two parallel solid lines
    case double
    /// A 3D grooved effect that depends on the border color
    case groove
    /// A 3D ridged effect that depends on the border color
    case ridge
    /// A 3D inset effect that depends on the border color
    case inset
    /// A 3D outset effect that depends on the border color
    case outset
}
