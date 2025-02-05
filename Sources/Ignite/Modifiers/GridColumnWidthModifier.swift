//
// GridColumnWidthModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

struct GridColumnWidthModifier: HTMLModifier {
    var width: ColumnWidth

    func body(content: some HTML) -> any HTML {
        content.columnWidth(width)
    }
}

public extension HTML {
    func width(_ width: Int) -> some HTML {
        modifier(GridColumnWidthModifier(width: .count(width)))
    }
}
