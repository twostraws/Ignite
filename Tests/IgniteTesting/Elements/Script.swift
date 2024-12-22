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
    func test_code() async throws {
        let element = Script(code: "javascript code")
        let output = element.render(context: publishingContext)

        #expect(output == "<script>javascript code</script>")
    }
    @Test("File Test")
    func test_file() async throws {
        let element = Script(file: "/code.js")
        let output = element.render(context: publishingContext)

        #expect(output == "<script src=\"/code.js\"></script>")
    }
    @Test("Attributes Test")
    func test_attributes() async throws {
        let element = Script(file: "/code.js")
            .data("key", "value")
            .customAttribute(name: "custom", value: "part")
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)
        #expect(
            normalizedOutput
                == "<script custom=\"part\" key=\"value\" src=\"/code.js\"></script>"
        )
    }
}
