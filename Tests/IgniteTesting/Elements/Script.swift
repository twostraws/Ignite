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
@MainActor struct ScriptTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Code Test")
    func code() async throws {
        let element = Script(code: "javascript code")
        let output = element.render(context: publishingContext)

        #expect(output == "<script>javascript code</script>")
    }
    @Test("File Test", arguments: ["/code.js"])
    func file(scriptFile: String) async throws {
        let element = Script(file: scriptFile)
        let output = element.render(context: publishingContext)

        #expect(output == "<script src=\"\(scriptFile)\"></script>")
    }
    @Test("Attributes Test", arguments: ["/code.js"])
    func attributes(scriptFile: String) async throws {
        let element = Script(file: scriptFile)
            .data("key", "value")
            .customAttribute(name: "custom", value: "part")
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)

        #expect(
            normalizedOutput
                == "<script custom=\"part\" key=\"value\" src=\"\(scriptFile)\"></script>"
        )
    }
}
