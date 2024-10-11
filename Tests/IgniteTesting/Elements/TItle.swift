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
struct TitleTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Empty Title Test")
    func test_empty() async throws {
        let element = Title("")
        let output = element.render(context: publishingContext)

        #expect(output == "<title> - My Test Site</title>")
    }
    @Test("Builder Test")
    func test_builder() async throws {
        let element = Title("Example Page")
        let output = element.render(context: publishingContext)

        #expect(output == "<title>Example Page - My Test Site</title>")
    }
}
