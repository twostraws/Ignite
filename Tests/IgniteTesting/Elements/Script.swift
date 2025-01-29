//
// Script.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `Script` element.
@Suite("Script Tests")
@MainActor
class ScriptTests: IgniteSuite {
    @Test("Code Test")
    func code() async throws {
        let element = Script(code: "javascript code")
        let output = element.render()
        #expect(output == "<script>javascript code</script>")
    }

    @Test("File Test", arguments: ["/code.js"])
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
}
