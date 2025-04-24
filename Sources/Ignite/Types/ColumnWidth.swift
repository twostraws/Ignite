//
// ColumnWidth.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// Controls how many columns a given block element takes up in a `Section`.
struct ColumnWidth: Equatable, Sendable {
    /// The Bootstrap class name for the column width.
    var className: String

    /// The column will expand to fill available space, distributing evenly with other `.uniform` columns.
    /// For example, if there are three `.uniform` elements in a 12-column section,
    /// each will automatically take up four columns.
    static let uniform = ColumnWidth(className: "col")

    /// The columns should be sized based on its content.
    static let intrinsic = ColumnWidth(className: "col-auto")

    /// This element should take up a precise number of columns.
    static func count(_ width: Int) -> Self {
        .init(className: "col-md-\(width)")
    }
}
