//
// HoverModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private extension HTML {
    func hoverModifier(hover: [Action], unhover: [Action]) -> any HTML {
        self
            .onEvent(.mouseOver, hover)
            .onEvent(.mouseOut, unhover)
    }
}

public extension HTML {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some HTML {
        AnyHTML(hoverModifier(hover: actions(true), unhover: actions(false)))
    }
}

public extension InlineElement {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this inline element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified inline HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some InlineElement {
        AnyHTML(hoverModifier(hover: actions(true), unhover: actions(false)))
    }
}
