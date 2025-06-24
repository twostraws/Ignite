//
// HoverModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds hover event handling to HTML elements.
struct HoverModifier: HTMLModifier {
    var hover: [Action]
    var unhover: [Action]
    func body(content: Content) -> some HTML {
        content
            .onEvent(.mouseOver, hover)
            .onEvent(.mouseOut, unhover)
    }
}

public extension HTML {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some HTML {
        modifier(HoverModifier(hover: actions(true), unhover: actions(false)))
    }
}
