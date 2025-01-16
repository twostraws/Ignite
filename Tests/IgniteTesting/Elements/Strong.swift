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
@MainActor struct StrongTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Single Element Test", arguments: ["This is a test", "Another test"])
    func test_singleElement(strongText: String) async throws {
        let element = Strong(strongText)
        let output = element.render(context: publishingContext)

        #expect(output == "<strong>\(strongText)</strong>")
    }

    @Test("Builder Test", arguments: ["This is a test", "Another test"])
    func test_builder(strongText: String) async throws {
        let element = Strong { strongText }
        let output = element.render(context: publishingContext)

        #expect(output == "<strong>\(strongText)</strong>")
    }
}
