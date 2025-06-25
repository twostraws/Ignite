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
    func gridCellColumns(_ width: Int) -> some HTML {
        self.style(.gridColumn, "span \(width)")
    }
}

public extension InlineElement {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func gridCellColumns(_ width: Int) -> some InlineElement {
        self.style(.gridColumn, "span \(width)")
    }
}

public extension HTML {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    @available(*, deprecated, message: """
    Please use gridCellColumns() or formControlWidth(). This method will be removed in a future release.
    """)
    func width(_ width: Int) -> some HTML {
        gridCellColumns(width)
    }
}
