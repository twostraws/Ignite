//
// EventModifiers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds hover event handlers to an HTML element.
struct HoverModifier: HTMLModifier {
    let hoverActions: [Action]
    let unhoverActions: [Action]

    func body(content: some HTML) -> any HTML {
        content
            .addEvent(name: "onmouseover", actions: hoverActions)
            .addEvent(name: "onmouseout", actions: unhoverActions)
    }
}

public extension HTML {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some HTML {
        modifier(HoverModifier(
            hoverActions: actions(true),
            unhoverActions: actions(false)
        ))
    }
}

public extension InlineElement {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this inline element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified inline HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some InlineElement {
        modifier(HoverModifier(
            hoverActions: actions(true),
            unhoverActions: actions(false)
        ))
    }
}

public extension BlockHTML {
    /// Adds "onmouseover" and "onmouseout" JavaScript events to this block element.
    /// - Parameter actions: A closure that takes a Boolean indicating hover state and returns actions to execute.
    /// - Returns: A modified block HTML element with the hover event handlers attached.
    func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> some BlockHTML {
        modifier(HoverModifier(
            hoverActions: actions(true),
            unhoverActions: actions(false)
        ))
    }
}
