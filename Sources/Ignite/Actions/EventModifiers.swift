//
// EventModifiers.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

extension PageElement {
    /// Adds an "onclick" JavaScript event to this element, running
    /// the provided actions when triggered.
    /// - Parameter actions: The actions to execute.
    /// - Returns: A copy of the current element with the event attached.
    public func onClick(@ElementBuilder<any Action> actions: () -> [Action]) -> Self {
        self.addingEvent(name: "onclick", actions: actions())
    }

    /// Adds an "ondblclick" JavaScript event to this element, running
    /// the provided actions when triggered.
    /// - Parameter actions: The actions to execute.
    /// - Returns: A copy of the current element with the event attached.
    public func onDoubleClick(@ElementBuilder<any Action> actions: () -> [Action]) -> Self {
        self.addingEvent(name: "ondblclick", actions: actions())
    }

    /// Adds "onmouseover" and "onmouseout" JavaScript events
    /// to this element, running the provided actions when triggered.
    /// - Parameter actions: The actions to execute. This must accept a Boolean
    /// that contains whether the user is currently hovering over this element or not.
    /// - Returns: A copy of the current element with the event attached.
    public func onHover(@ElementBuilder<any Action> actions: (_ isHovering: Bool) -> [Action]) -> Self {
        var copy = self
        copy.addEvent(name: "onmouseover", actions: actions(true))
        copy.addEvent(name: "onmouseout", actions: actions(false))
        return copy
    }
}
