//
//  Clipped.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Clipped` modifier.
@Suite("Clipped Tests")
@MainActor
struct ClippedTests {
    @Test("Clipped Modifier")
    func clippedModifier() async throws {
        let element = Text("Hello").clipped()
        let output = element.render()
        #expect(output == "<p style=\"overflow: hidden\">Hello</p>")
    }
}
