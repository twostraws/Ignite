//
//  ToggleElementVisibility.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ToggleElementVisibility` action.
@Suite("ToggleElementVisibility Tests")
@MainActor
struct ToggleElementVisibilityTests {
    @Test("Compiles to classList.toggle with d-none")
    func compilesToToggle() async throws {
        let action = ToggleElementVisibility("myElement")
        let output = action.compile()
        #expect(output == "document.getElementById('myElement').classList.toggle('d-none')")
    }

    @Test("Embeds element ID in output")
    func embedsElementID() async throws {
        let action = ToggleElementVisibility("sidebar-panel")
        let output = action.compile()
        #expect(output.contains("'sidebar-panel'"))
    }
}
