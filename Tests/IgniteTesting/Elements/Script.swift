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
struct ScriptTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
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
            .addCustomAttribute(name: "custom", value: "part")
        let output = element.render(context: publishingContext)

        #expect(output == "<script custom=\"part\" data-key=\"value\" src=\"/code.js\"></script>")
    }
}
