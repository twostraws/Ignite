//
//  HideElement.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `HideElement` action.
@Suite("HideElement Tests")
struct HideElementTests {
    @Test("Compiles to classList.add with d-none", .publishingContext())
    func compilesToAdd() async throws {
        let action = HideElement("myElement")
        let output = action.compile()
        #expect(output == "document.getElementById('myElement').classList.add('d-none')")
    }

    @Test("Embeds element ID in output", .publishingContext())
    func embedsElementID() async throws {
        let action = HideElement("content-panel")
        let output = action.compile()
        #expect(output.contains("'content-panel'"))
    }
}
