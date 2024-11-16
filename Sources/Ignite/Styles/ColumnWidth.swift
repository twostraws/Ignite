//
// ColumnWidth.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Controls how many columns a given block element takes up in a `Section`.
public enum ColumnWidth {
    /// The system will divide the available space automatically. For example,
    /// if there are three automatically sized elements in a 12-column section,
    /// each will be allocated four columns.
    case automatic

    /// This element should take up a precise number of columns.
    case count(Int)

    /// Returns the Bootstrap class name for the column width.
    var className: String {
        switch self {
        case .automatic:
            "col"
        case .count(let int):
            "col-md-\(int)"
        }
    }
}
