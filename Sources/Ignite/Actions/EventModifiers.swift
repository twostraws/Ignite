//
// EventModifiers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

extension HTML {
    /// Adds an "onclick" JavaScript event to this element, running
    /// the provided actions when triggered.
    /// - Parameter actions: The actions to execute.
    /// - Returns: A copy of the current element with the event attached.
    public func onClick(@ActionBuilder actions: () -> [Action]) -> Self {
        self.addEvent(name: "onclick", actions: actions())
    }

    /// Adds an "ondblclick" JavaScript event to this element, running
    /// the provided actions when triggered.
    /// - Parameter actions: The actions to execute.
    /// - Returns: A copy of the current element with the event attached.
    public func onDoubleClick(@ActionBuilder actions: () -> [Action]) -> Self {
        self.addEvent(name: "ondblclick", actions: actions())
    }

    /// Adds "onmouseover" and "onmouseout" JavaScript events
    /// to this element, running the provided actions when triggered.
    /// - Parameter actions: The actions to execute. This must accept a Boolean
    /// that contains whether the user is currently hovering over this element or not.
    /// - Returns: A copy of the current element with the event attached.
    public func onHover(@ActionBuilder actions: (_ isHovering: Bool) -> [Action]) -> Self {
        self.addEvent(name: "onmouseover", actions: actions(true))
        self.addEvent(name: "onmouseout", actions: actions(false))
        return self
    }
}
