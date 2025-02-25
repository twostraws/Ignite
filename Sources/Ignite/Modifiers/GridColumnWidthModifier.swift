//
// GridColumnWidthModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct GridColumnWidthModifier: HTMLModifier {
    var width: ColumnWidth

    func body(content: some HTML) -> any HTML {
        var copy = content
        copy.attributes.add(classes: width.className)
        return copy
    }
}

public extension HTML {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func width(_ width: Int) -> some HTML {
        modifier(GridColumnWidthModifier(width: .count(width)))
    }
}
