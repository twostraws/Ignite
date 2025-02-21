//
// EventModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds event attributes to an HTML element.
struct EventModifier: HTMLModifier {
    let type: EventType
    let actions: [Action]

    func body(content: some HTML) -> any HTML {
        guard !actions.isEmpty else { return content }
        var copy = content
        copy.attributes.events.append(Event(name: type.rawValue, actions: actions))
        AttributeStore.default.merge(copy.attributes, intoHTML: copy.id)
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
        modifier(EventModifier(type: type, actions: actions))
    }
}

public extension InlineElement {
    /// Adds an event attribute to the `InlineHTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some InlineElement {
        modifier(EventModifier(type: type, actions: actions))
    }
}
