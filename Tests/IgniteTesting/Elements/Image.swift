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
@MainActor class ImageTests: IgniteTestSuite {
    @Test("Local Image", arguments: ["/images/example.jpg"], ["Example image"])
    func named(file: String, description: String) async throws {
        let element = Image(file, description: description)
        let output = element.render()

        let expectedPath = PublishingContext.shared.path(for: URL(string: file)!)
        #expect(output == "<img src=\"\(expectedPath)\" alt=\"\(description)\" />")
    }

    @Test("Remote Image", arguments: ["https://example.com"], ["Example image"])
    func named(url: String, description: String) async throws {
        let element = Image(url, description: description)
        let output = element.render()

        let expectedPath = PublishingContext.shared.path(for: URL(string: url)!)
        #expect(output == "<img src=\"\(expectedPath)\" alt=\"\(description)\" />")
    }

    @Test("Icon Image", arguments: ["browser-safari"], ["Safari logo"])
    func icon(systemName: String, description: String) async throws {
        let element = Image(systemName: systemName, description: description)
        let output = element.render()
        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
