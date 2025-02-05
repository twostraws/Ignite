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
        content.addEvent(name: type.rawValue, actions: actions)
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

public extension InlineHTML {
    /// Adds an event attribute to the `InlineHTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some InlineHTML {
        modifier(EventModifier(type: type, actions: actions))
    }
}
