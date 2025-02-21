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
class ClippedTests: IgniteTestSuite {
    @Test("Clipped Modifier")
    func clippedModifier() async throws {
        let element = Text("Hello").clipped()
        let output = element.render()
        #expect(output == "<p style=\"overflow: hidden\">Hello</p>")
    }

    @Test("Clipped Modifier on Custom Element")
    func clippedModifier_onCustomElement() async throws {
        let element = TestElement().clipped()
        let output = element.render()
        #expect(output == """
        <div style=\"overflow: hidden\">\
        <p>Test Heading!</p>\
        <p>Test Subheading</p>\
        <label>Test Label</label>\
        </div>
        """)
    }
}
