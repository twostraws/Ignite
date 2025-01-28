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
    static let sites: [any Site] = [TestSite(), TestSubsite()]

    @Test("Image Test", arguments:
        [(path: "/images/example.jpg", description: "Example image")],
        await sites)
    func named(image: (path: String, description: String), for site: any Site) async throws {
        @SiteDependent(site) var element = Image(image.path, description: image.description)
        let output = element.render()

        let expectedPath = site.url.path == "/" ? image.path : "\(site.url.path)\(image.path)"
        #expect(output == "<img alt=\"Example image\" src=\"\(expectedPath)\" />")
    }

    @Test("Icon Image Test", arguments: ["browser-safari"], ["Safari logo"])
    func icon(systemName: String, description: String) async throws {
        let element = Image(systemName: systemName, description: description)
        let output = element.render()

        #expect(output == "<i class=\"bi-browser-safari\"></i>")
    }
}
