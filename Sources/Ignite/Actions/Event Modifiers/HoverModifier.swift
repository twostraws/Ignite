//
// HoverModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor private func hoverModifier(
    hover: [Action],
    unhover: [Action],
    content: any HTML
) -> any HTML {
    content
        .onEvent(.mouseOver, hover)
        .onEvent(.mouseOut, unhover)
}

@MainActor private func hoverModifier(
    hover: [Action],
    unhover: [Action],
    content: any InlineElement
) -> any InlineElement {
    content
        .onEvent(.mouseOver, hover)
        .onEvent(.mouseOut, unhover)
}

public extension HTML {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some HTML {
        AnyHTML(hoverModifier(hover: actions(true), unhover: actions(false), content: self))
    }
}

public extension InlineElement {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this inline element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified inline HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some InlineElement {
        AnyInlineElement(hoverModifier(hover: actions(true), unhover: actions(false), content: self))
    }
}
