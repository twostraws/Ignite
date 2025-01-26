//
// Title.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `title` element.
@Suite("Title Tests")
@MainActor struct TitleTests {
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Empty Title Test", arguments: [""])
    func empty(emptyTitleText: String) async throws {
        let element = Title(emptyTitleText)
        let output = element.render()

        #expect(output == "<title>\(emptyTitleText) - My Test Site</title>")
    }

    @Test("Builder Test", arguments: ["Example Page", "Another Example Page"])
    func builder(titleText: String) async throws {
        let element = Title(titleText)
        let output = element.render()

        #expect(output == "<title>\(titleText) - My Test Site</title>")
    }
}
