//
// ColumnWidth.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Controls how many columns a given block element takes up in a `Grid`.
enum ColumnWidth {
    /// The column will expand to fill available space,
    /// distributing evenly with other `.uniform` columns.
    /// For example, if there are three `.uniform`elements
    /// in a 12-column section, each will automatically
    /// take up four columns.
    case uniform

    /// The columns should be sized based on its content.
    case variable

    /// This element should take up a precise number of columns.
    case count(Int)

    /// The Bootstrap class name for the column width.
    var className: String {
        switch self {
        case .uniform: "col"
        case .variable: "col-auto"
        case .count(let width): "col-md-\(width)"
        }
    }

    /// Returns the Bootstrap class name for the column width.
    func callAsFunction() -> String {
        className
    }
}
