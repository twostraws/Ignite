//
// DoubleClickModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adds an "ondblclick" JavaScript event to this element.
    /// - Parameter actions: A closure that returns the actions to execute when double-clicked.
    /// - Returns: A modified HTML element with the double click event handler attached.
    func onDoubleClick(@ActionBuilder actions: () -> [Action]) -> some HTML {
        self.onEvent(.doubleClick, actions())
    }
}

public extension InlineElement {
    /// Adds an "ondblclick" JavaScript event to this inline element.
    /// - Parameter actions: A closure that returns the actions to execute when double-clicked.
    /// - Returns: A modified inline HTML element with the double click event handler attached.
    func onDoubleClick(@ActionBuilder actions: () -> [Action]) -> some InlineElement {
        self.onEvent(.doubleClick, actions())
    }
}
