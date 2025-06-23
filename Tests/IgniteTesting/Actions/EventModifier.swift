//
//  EventModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `EventModifier` action.
@Suite("EventModifier Tests")
@MainActor
class EventModifierTests: IgniteTestSuite {
    private nonisolated static let tags: [String] = ["body", "btn", "img", "div", "section"]

    private static let events: [EventType] = [
        EventType.click,
        EventType.doubleClick,
        EventType.focus,
        EventType.load,
        EventType.mouseOver
    ]

    private static let actions: [[Action]] = [
        [ShowAlert(message: "foo")],
        [ShowAlert(message: "qux"), DismissModal(id: "baz")],
        [CustomAction("document.writeline('bar')")],
        [CustomAction("document.writeline('foo')"), ShowElement("qux")],
        [ShowModal(id: "foo"), HideElement("qux")]
    ]

    @Test("Events are added", arguments: tags, await Array(zip(events, actions)))
    func eventsAdded(tag: String, eventActions: (EventType, [any Action])) async throws {
        let element = Tag(tag) {}
            .onEvent(eventActions.0, eventActions.1)

        let output = element.render()

        let eventOutput = eventActions.0.rawValue
        let actionOutput = eventActions.1.map { $0.compile() }.joined(separator: "; ")

        #expect(output.string == "<\(tag) \(eventOutput)=\"\(actionOutput)\"></\(tag)>")
    }
}
