//
// DoubleClickModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds a double click event handler to an HTML element.
struct DoubleClickModifier: HTMLModifier {
    let actions: [Action]

    func body(content: some HTML) -> any HTML {
        content.addEvent(name: "ondblclick", actions: actions)
    }
}

public extension HTML {
    /// Adds an "ondblclick" JavaScript event to this element.
    /// - Parameter actions: A closure that returns the actions to execute when double-clicked.
    /// - Returns: A modified HTML element with the double click event handler attached.
    func onDoubleClick(@ActionBuilder actions: () -> [Action]) -> some HTML {
        modifier(DoubleClickModifier(actions: actions()))
    }
}

public extension InlineElement {
    /// Adds an "ondblclick" JavaScript event to this inline element.
    /// - Parameter actions: A closure that returns the actions to execute when double-clicked.
    /// - Returns: A modified inline HTML element with the double click event handler attached.
    func onDoubleClick(@ActionBuilder actions: () -> [Action]) -> some InlineElement {
        modifier(DoubleClickModifier(actions: actions()))
    }
}

public extension BlockHTML {
    /// Adds an "ondblclick" JavaScript event to this block element.
    /// - Parameter actions: A closure that returns the actions to execute when double-clicked.
    /// - Returns: A modified block HTML element with the double click event handler attached.
    func onDoubleClick(@ActionBuilder actions: () -> [Action]) -> some BlockHTML {
        modifier(DoubleClickModifier(actions: actions()))
    }
}
