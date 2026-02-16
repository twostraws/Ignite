//
//  SwitchTheme.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `SwitchTheme` action.
@Suite("SwitchTheme Tests")
@MainActor
class SwitchThemeTests: IgniteTestSuite {
    @Test("Light theme compiles to igniteSwitchTheme with light ID")
    func lightTheme() async throws {
        let action = SwitchTheme(.light)
        #expect(action.compile() == "igniteSwitchTheme('light');")
    }

    @Test("Dark theme compiles to igniteSwitchTheme with dark ID")
    func darkTheme() async throws {
        let action = SwitchTheme(.dark)
        #expect(action.compile() == "igniteSwitchTheme('dark');")
    }
}
