//
// FormControlWidthModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func formControlWidth(_ width: Int) -> some HTML {
        FormColumn(width: width, content: self)
    }
}

public extension InlineElement {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A new element with the adjusted column width.
    func formControlWidth(_ width: Int) -> some HTML {
        FormColumn(width: width, content: self)
    }
}

public extension Button {
    /// Adjusts the number of columns assigned to this element.
    /// - Parameter width: The new number of columns to use.
    /// - Returns: A copy of the current element with the adjusted column width.
    func formControlWidth(_ width: Int) -> some HTML {
        FormColumn(width: width, content: self.class("w-100 h-100"))
    }
}
