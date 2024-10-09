//
// SubsiteImage.swift                               
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

import Testing
@testable import Ignite

/// Tests for the `Image` element.
@Suite("Subsite Image Tests")
struct SubsiteImageTests {
    /// A publishing context with sample values for subsite tests.
    let publishingSubsiteContext = try! PublishingContext(for: TestSubsite(), from: "Test Subsite")

    @Test("Image Test")
    func test_image_named() async throws {
        let element = Image("/images/example.jpg", description: "Example image")
        let output = element.render(context: publishingSubsiteContext)

        #expect(output == "<img src=\"/subsite/images/example.jpg\" alt=\"Example image\"/>")
    }
    @Test("Icon Test")
    func test_image_icon() async throws {
        let element = Image(systemName: "browser-safari", description: "Safari logo")
        let output = element.render(context: publishingSubsiteContext)

        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
