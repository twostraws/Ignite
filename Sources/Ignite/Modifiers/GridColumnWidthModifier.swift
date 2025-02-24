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
        copy.attributes.append(classes: width.className)
        return copy
    }
}

public extension HTML {
    func width(_ width: Int) -> some HTML {
        modifier(GridColumnWidthModifier(width: .count(width)))
    }
}
