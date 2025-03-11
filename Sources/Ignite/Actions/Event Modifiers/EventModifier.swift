//
// EventModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

private extension HTML {
    func eventModifier(type: EventType, actions: [Action]) -> any HTML {
        guard !actions.isEmpty else { return self }
        // Custom elements need to be wrapped in a primitive container to store attributes
        var copy: any HTML = self.isPrimitive ? self : Section(self)
        copy.attributes.events.append(Event(name: type.rawValue, actions: actions))
        return copy
    }
}

public extension HTML {
    /// Adds an event attribute to the `HTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some HTML {
        AnyHTML(eventModifier(type: type, actions: actions))
    }
}

public extension InlineElement {
    /// Adds an event attribute to the `InlineHTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some InlineElement {
        AnyHTML(eventModifier(type: type, actions: actions))
    }
}
