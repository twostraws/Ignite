//
// GridColumnWidthModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func width(_ width: Int) -> some HTML {
        AnyHTML(gridColumnWidthModifier(width))
    }
}

public extension InlineElement {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func width(_ width: Int) -> some InlineElement {
        AnyHTML(gridColumnWidthModifier(width))
    }
}

private extension HTML {
    func gridColumnWidthModifier(_ width: Int) -> any HTML {
        // Custom elements need to be wrapped in a primitive container to store attributes
        var copy: any HTML = self.isPrimitive ? self : Section(self)
        copy.attributes.append(classes: ColumnWidth.count(width).className)
        return copy
    }
}
