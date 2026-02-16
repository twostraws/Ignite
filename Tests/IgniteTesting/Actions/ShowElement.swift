//
//  ShowElement.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ShowElement` action.
@Suite("ShowElement Tests")
@MainActor
struct ShowElementTests {
    @Test("Compiles to classList.remove with d-none")
    func compilesToRemove() async throws {
        let action = ShowElement("myElement")
        let output = action.compile()
        #expect(output == "document.getElementById('myElement').classList.remove('d-none')")
    }

    @Test("Embeds element ID in output")
    func embedsElementID() async throws {
        let action = ShowElement("sidebar")
        let output = action.compile()
        #expect(output.contains("'sidebar'"))
    }
}
