//
//  EventType.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `EventType` enum.
@Suite("EventType Tests")
@MainActor
struct EventTypeTests {
    @Test("All raw values start with on prefix", arguments: EventType.allCases)
    func allRawValuesStartWithOn(eventType: EventType) async throws {
        #expect(eventType.rawValue.hasPrefix("on"),
                "Expected \(eventType) raw value '\(eventType.rawValue)' to start with 'on'")
    }

    @Test("Representative raw values match HTML event attributes", arguments: [
        (EventType.click, "onclick"),
        (.doubleClick, "ondblclick"),
        (.mouseDown, "onmousedown"),
        (.keyDown, "onkeydown"),
        (.load, "onload"),
        (.submit, "onsubmit"),
        (.focus, "onfocus"),
        (.blur, "onblur"),
        (.scroll, "onscroll"),
        (.dragStart, "ondragstart"),
        (.copy, "oncopy"),
        (.touchStart, "ontouchstart"),
        (.pointerDown, "onpointerdown"),
        (.animationEnd, "onanimationend"),
        (.transitionEnd, "ontransitionend"),
        (.visibilityChange, "onvisibilitychange"),
        (.toggle, "ontoggle")
    ])
    func rawValuesMatchHTMLAttributes(eventType: EventType, expected: String) async throws {
        #expect(eventType.rawValue == expected)
    }

    @Test("withoutPrefix strips on prefix", arguments: [
        (EventType.click, "click"),
        (.doubleClick, "dblclick"),
        (.mouseOver, "mouseover"),
        (.keyDown, "keydown"),
        (.submit, "submit"),
        (.animationEnd, "animationend"),
        (.transitionEnd, "transitionend")
    ])
    func withoutPrefixStripsOnPrefix(eventType: EventType, expected: String) async throws {
        #expect(eventType.withoutPrefix == expected)
    }
}
