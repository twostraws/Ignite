//
// HoverInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds hover event handling to inline HTML elements.
struct HoverInlineModifier: InlineElementModifier {
    var hover: [Action]
    var unhover: [Action]
    func body(content: Content) -> some InlineElement {
        content
            .onEvent(.mouseOver, hover)
            .onEvent(.mouseOut, unhover)
    }
}

public extension InlineElement {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this inline element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified inline HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some InlineElement {
        modifier(HoverInlineModifier(hover: actions(true), unhover: actions(false)))
    }
}
