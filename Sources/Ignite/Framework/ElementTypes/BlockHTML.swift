//
// BlockElement.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Describes a HTML element that is rendered in block style, i.e. that it occupies the
/// full width of the page by default.
public protocol BlockHTML: HTML, HorizontalAligning {
    /// How many columns this should occupy when placed in a section.
    var columnWidth: ColumnWidth { get set }

    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A copy of the current element with the adjusted column width.
    func width(_ width: Int) -> Self
}

extension BlockHTML {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A copy of the current element with the adjusted column width.
    public func width(_ width: Int) -> Self {
        var copy = self
        copy.columnWidth = .count(width)

        // Important: We need to transfer all our existing
        // attributes over to the copy.
        AttributeStore.default.merge(attributes, intoHTML: copy.id)

        return copy
    }
}
