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
struct EventModifierTests {
    private nonisolated static let tags: [String] = ["body", "btn", "img", "div", "section"]

    private static let events: [EventType] = [
        EventType.click,
        EventType.doubleClick,
        EventType.focus,
        EventType.load,
        EventType.mouseOver
    ]

    private static let actions: [[any Action]] = [
        [ShowAlert(message: "foo")],
        [ShowAlert(message: "qux"), DismissModal(id: "baz")],
        [CustomAction("document.writeline('bar')")],
        [CustomAction("document.writeline('foo')"), ShowElement("qux")],
        [ShowModal(id: "foo"), HideElement("qux")]
    ]

    @Test("Check if events are added correctly", arguments: tags)
    func onEventAddsEventsCorrectly(tag: String) async throws {
        zip(Self.events, Self.actions).forEach { event, actions in
            let element = Tag(tag) {}
                .onEvent(event, actions)

            let output = element.render()

            let eventOutput = event.rawValue
            let actionOutput = actions.map { $0.compile() }.joined(separator: "; ")

            #expect(output == "<\(tag) \(eventOutput)=\"\(actionOutput)\"></\(tag)>")
        }
    }
}
