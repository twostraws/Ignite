//
// ColumnVerticalAlignment.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// How to vertically align the contents of this column.
public enum ColumnVerticalAlignment: String, Sendable, CaseIterable {
    /// Align contents to the top of the column.
    case top

    /// Align contents to the middle of the column.
    case middle

    /// Align contents to the bottom of the column.
    case bottom
}
