//
// PlainText.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import Testing
@testable import Ignite

/// Tests for plain text.
@Suite("Plain Text Tests")
struct PlainTextTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Single Element")
    func test_singleElement() async throws {
        let element = "This is a test"
        let output = element.render(context: publishingContext)

        #expect(output == "This is a test")
    }
}
