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
class ScriptTests: UITestSuite {
    static let sites: [any Site] = [TestSite(), TestSubsite()]

    @Test("Code Test", arguments: await sites)
    func code(for site: any Site) async throws {
        @SiteDependent(site) var element = Script(code: "javascript code")
        let output = element.render()
        #expect(output == "<script>javascript code</script>")
    }

    @Test("File Test", arguments: ["/code.js"], await sites)
    func file(scriptFile: String, site: any Site) async throws {
        @SiteDependent(site) var element = Script(file: scriptFile)
        let output = element.render()

        let expectedPath = site.url.appending(path: scriptFile).decodedPath
        #expect(output == "<script src=\"\(expectedPath)\"></script>")
    }

    @Test("Attributes Test", arguments: ["/code.js"], await sites)
    func attributes(scriptFile: String, site: any Site) async throws {
        @SiteDependent(site) var element = Script(file: scriptFile)
            .data("key", "value")
            .customAttribute(name: "custom", value: "part")
        let output = element.render()

        let expectedPath = site.url.appending(path: scriptFile).decodedPath
        #expect(output == "<script custom=\"part\" src=\"\(expectedPath)\" data-key=\"value\"></script>")
    }
}
