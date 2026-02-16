//
//  AnimationTrigger.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `AnimationTrigger`.
@Suite("AnimationTrigger Tests")
@MainActor
struct AnimationTriggerTests {
    @Test("Raw values match expected strings", arguments: zip(
        [AnimationTrigger.click, .hover, .appear],
        ["click", "hover", "appear"]))
    func rawValues(trigger: AnimationTrigger, expected: String) async throws {
        #expect(trigger.rawValue == expected)
    }

    @Test("CaseIterable returns all 3 cases")
    func allCasesCount() async throws {
        #expect(AnimationTrigger.allCases.count == 3)
    }
}
