//
// Image.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import Testing
@testable import Ignite

/// Tests for the `Image` element.
@Suite("Image Tests")
struct ImageTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Image Test")
    func test_named() async throws {
        let element = Image("/images/example.jpg", description: "Example image")
        let output = element.render(context: publishingContext)

        #expect(output == "<img src=\"/images/example.jpg\" alt=\"Example image\"/>")
    }
    @Test("Icon Image Test")
    func test_icon() async throws {
        let element = Image(systemName: "browser-safari", description: "Safari logo")
        let output = element.render(context: publishingContext)

        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
