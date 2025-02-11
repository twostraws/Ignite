//
// ClickModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds a click event handler to an HTML element.
struct ClickModifier: HTMLModifier {
    let actions: [Action]

    func body(content: some HTML) -> any HTML {
        content.addEvent(name: "onclick", actions: actions)
    }
}

public extension HTML {
    /// Adds an "onclick" JavaScript event to this element.
    /// - Parameter actions: A closure that returns the actions to execute when clicked.
    /// - Returns: A modified HTML element with the click event handler attached.
    func onClick(@ActionBuilder actions: () -> [Action]) -> some HTML {
        modifier(ClickModifier(actions: actions()))
    }
}

public extension InlineElement {
    /// Adds an "onclick" JavaScript event to this inline element.
    /// - Parameter actions: A closure that returns the actions to execute when clicked.
    /// - Returns: A modified inline HTML element with the click event handler attached.
    func onClick(@ActionBuilder actions: () -> [Action]) -> some InlineElement {
        modifier(ClickModifier(actions: actions()))
    }
}

public extension BlockHTML {
    /// Adds an "onclick" JavaScript event to this block element.
    /// - Parameter actions: A closure that returns the actions to execute when clicked.
    /// - Returns: A modified block HTML element with the click event handler attached.
    func onClick(@ActionBuilder actions: () -> [Action]) -> some BlockHTML {
        modifier(ClickModifier(actions: actions()))
    }
}
