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
@MainActor
class ImageTests: UITestSuite {
    @Test("Image Test", arguments: ["/images/example.jpg"], ["Example image"])
    func named(path: String, description: String) async throws {
        let element = Image(path, description: description)
        let output = element.render()
        #expect(output == "<img alt=\"Example image\" src=\"\(path)\" />")
    }

    @Test("Icon Image Test", arguments: ["browser-safari"], ["Safari logo"])
    func icon(systemName: String, description: String) async throws {
        let element = Image(systemName: systemName, description: description)
        let output = element.render()
        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
