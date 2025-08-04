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
@MainActor class ScriptTests: IgniteTestSuite {
    static let sites: [any Site] = [TestSite(), TestSubsite()]

    @Test("Code", arguments: await Self.sites)
    func code(for site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Script(code: "javascript code")
        let output = element.render().string

        #expect(output == "<script>javascript code</script>")
    }

    @Test("Local File", arguments: ["/code.js"], await Self.sites)
    func file(scriptFile: String, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Script(file: scriptFile)
        let output = element.render().string

        let expectedPath = PublishingContext.shared.path(for: URL(string: scriptFile)!)
        #expect(output == "<script src=\"\(expectedPath)\"></script>")
    }

    @Test("Remote File", arguments: ["https://example.com"], await Self.sites)
    func file(remoteScript: String, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Script(file: remoteScript)
        let output = element.render().string

        let expectedPath = PublishingContext.shared.path(for: URL(string: remoteScript)!)
        #expect(output == "<script src=\"\(expectedPath)\"></script>")
    }

    @Test("Attributes", arguments: ["/code.js"], await Self.sites)
    func attributes(scriptFile: String, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Script(file: scriptFile)
            .data("key", "value")
            .customAttribute(name: "custom", value: "part")
        let output = element.markupString()

        let expectedPath = PublishingContext.shared.path(for: URL(string: scriptFile)!)
        #expect(output == "<script custom=\"part\" src=\"\(expectedPath)\" data-key=\"value\"></script>")
    }
}
