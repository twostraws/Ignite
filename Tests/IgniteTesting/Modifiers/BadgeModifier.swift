//
//  BadgeModifier.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `BadgeModifier` modifier.
@Suite("BadgeModifier Tests")
@MainActor
struct BadgeModifierTests {
    @Test("Badge Modifier for InlineHTML")
    func badgeModifierForInlineHTML() async throws {
        let element = Text("Notifications").badge(Badge("3"))
        let output = element.render()
        #expect(
            output == "<li class=\"align-items-center d-flex justify-content-between\">" +
            "<p>Notifications</p><span class=\"badge rounded-pill\">3</span></li>"
        )
    }

    @Test("Badge Modifier for ListItem")
    func badgeModifierForListItem() async throws {
        let element = ListItem {
            Text("Messages")
        }.badge(Badge("5"))
        let output = element.render()
        #expect(
            output == "<li class=\"align-items-center d-flex justify-content-between\">" +
            "<p>Messages</p></li>"
        )
    }
}
