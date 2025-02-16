//
// Strong.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Strong` element.
@Suite("Strong Tests")
@MainActor class StrongTests: IgniteTestSuite {
    @Test("Single Element", arguments: ["This is a test", "Another test", ""])
    func singleElement(strongText: String) async throws {
        let element = Strong(strongText)
        let output = element.render()

        #expect(output == "<strong>\(strongText)</strong>")
    }

    @Test("Builder", arguments: ["This is a test", "Another test", ""])
    func builder(strongText: String) async throws {
        let element = Strong { strongText }
        let output = element.render()

        #expect(output == "<strong>\(strongText)</strong>")
    }
}
