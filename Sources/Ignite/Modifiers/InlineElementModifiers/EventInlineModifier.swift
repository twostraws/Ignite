//
// EventInlineModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

/// A modifier that adds event handling to inline elements.
private struct EventInlineModifier: InlineElementModifier {
    /// The type of event to handle.
    var type: EventType
    /// The actions to execute when the event occurs.
    var actions: [Action]

    /// Creates the modified inline element with event handling.
    /// - Parameter content: The content to modify.
    /// - Returns: The modified inline element with event attributes.
    func body(content: Content) -> some InlineElement {
        var content = content
        guard !actions.isEmpty else { return content }
        content.attributes.events.append(Event(name: type.rawValue, actions: actions))
        return content
    }
}

public extension InlineElement {
    /// Adds an event attribute to the `InlineHTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some InlineElement {
        modifier(EventInlineModifier(type: type, actions: actions))
    }
}
