//
// GridColumnWidthModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
private func gridColumnWidthModifier(_ width: Int, content: any HTML) -> AnyHTML {
    if content.isPrimitive {
        AnyHTML(content.class(ColumnWidth.count(width).className))
    } else {
        AnyHTML(Section(content).class(ColumnWidth.count(width).className))
    }
}

public extension HTML {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func width(_ width: Int) -> some Element {
        gridColumnWidthModifier(width, content: self)
    }
}

public extension FormItem {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func width(_ width: Int) -> some FormItem {
        gridColumnWidthModifier(width, content: self)
    }
}
