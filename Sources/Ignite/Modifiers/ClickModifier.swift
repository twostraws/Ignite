//
// ClickModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

public extension HTML {
    /// Adds an "onclick" JavaScript event to this element.
    /// - Parameter actions: A closure that returns the actions to execute when clicked.
    /// - Returns: A modified HTML element with the click event handler attached.
    func onClick(@ActionBuilder actions: () -> [Action]) -> some HTML {
        self.onEvent(.click, actions())
    }
}

public extension InlineElement {
    /// Adds an "onclick" JavaScript event to this inline element.
    /// - Parameter actions: A closure that returns the actions to execute when clicked.
    /// - Returns: A modified inline HTML element with the click event handler attached.
    func onClick(@ActionBuilder actions: () -> [Action]) -> some InlineElement {
        self.onEvent(.click, actions())
    }
}
