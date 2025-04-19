//
// EventModifier.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@MainActor
private func eventModifier(
    _ type: EventType,
    actions: [Action],
    content: any Element
) -> any Element {
    guard !actions.isEmpty else { return content }
    var copy: any Element = content.isPrimitive ? content : Section(content)
    copy.attributes.events.append(Event(name: type.rawValue, actions: actions))
    return copy
}

@MainActor
private func eventModifier(
    _ type: EventType,
    actions: [Action],
    content: any InlineElement
) -> any InlineElement {
    guard !actions.isEmpty else { return content }
    var copy: any InlineElement = content.isPrimitive ? content : Span(content)
    copy.attributes.events.append(Event(name: type.rawValue, actions: actions))
    return copy
}

public extension Element {
    /// Adds an event attribute to the `HTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some Element {
        AnyHTML(eventModifier(type, actions: actions, content: self))
    }
}

public extension InlineElement {
    /// Adds an event attribute to the `InlineHTML` element.
    /// - Parameters:
    ///   - type: The name of the attribute.
    ///   - actions: Array of actions to execute when the event occurs
    /// - Returns: A modified HTML element with the specified attribute.
    func onEvent(_ type: EventType, _ actions: [Action]) -> some InlineElement {
        AnyInlineElement(eventModifier(type, actions: actions, content: self))
    }
}
