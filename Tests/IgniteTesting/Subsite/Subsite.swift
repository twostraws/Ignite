//
// Image.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for subsites.
@Suite("Subsite Tests")
@MainActor
class SubsiteImageTests: UISubsiteTestSuite {

    // MARK: - Image
    @Test("Image Test", arguments: ["/images/example.jpg"], ["Example image"])
    func named(path: String, description: String) async throws {
        let element = Image(path, description: description)
        let output = element.render()
        let path = site.url.appending(path: path).decodedPath
        #expect(output == "<img alt=\"Example image\" src=\"\(path)\" />")
    }

    // MARK: - Script
    @Test("Script File Test", arguments: ["/code.js"])
    func file(scriptFile: String) async throws {
        let element = Script(file: scriptFile)
        let output = element.render()
        let expectedPath = site.url.appending(path: scriptFile).decodedPath
        #expect(output == "<script src=\"\(expectedPath)\"></script>")
    }

    @Test("Attributes Test", arguments: ["/code.js"])
    func attributes(scriptFile: String) async throws {
        let element = Script(file: scriptFile)
            .data("key", "value")
            .customAttribute(name: "custom", value: "part")
        let output = element.render()

        let expectedPath = site.url.appending(path: scriptFile).decodedPath
        #expect(output == "<script custom=\"part\" src=\"\(expectedPath)\" data-key=\"value\"></script>")
    }

    // MARK: - Link
}
