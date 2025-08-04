//
// Subsite.swift
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
class SubsiteTests: IgniteSubsiteTestSuite {
    // MARK: - Image

    @Test("Image Test", arguments: ["/images/example.jpg"], ["Example image"])
    func named(path: String, description: String) async throws {
        let element = Image(path, description: description)
        let output = element.markupString()
        let path = publishingContext.path(for: URL(string: path)!)
        #expect(output == "<img src=\"\(path)\" alt=\"Example image\" />")
    }

    // MARK: - Body

    @Test("Body Test")
    func body() async throws {
        publishingContext.environment.pageContent = Text("TEXT")

        let element = Body()
        let output = element.render().string
        let path = publishingContext.path(for: URL(string: "/js")!)

        #expect(output == """
        <body class="container"><p>TEXT</p>\
        <script src="\(path)/bootstrap.bundle.min.js"></script>\
        <script src="\(path)/ignite-core.js"></script>\
        </body>
        """)
    }

    // MARK: - Script

    @Test("Script File Test", arguments: ["/code.js"])
    func file(scriptFile: String) async throws {
        let element = Script(file: scriptFile)
        let output = element.render().string
        let expectedPath = publishingContext.path(for: URL(string: scriptFile)!)
        #expect(output == "<script src=\"\(expectedPath)\"></script>")
    }

    @Test("Attributes Test", arguments: ["/code.js"])
    func attributes(scriptFile: String) async throws {
        let element = Script(file: scriptFile)
            .data("key", "value")
            .customAttribute(name: "custom", value: "part")
        let output = element.markupString()

        let expectedPath = publishingContext.path(for: URL(string: scriptFile)!)
        #expect(output == "<script custom=\"part\" src=\"\(expectedPath)\" data-key=\"value\"></script>")
    }

    // MARK: - Link

    @Test("String Target Test", arguments: ["/"], ["Go Home"])
    func target(for target: String, description: String) async throws {
        let element = Link(description, target: target)
        let output = element.markupString()
        let expectedPath = publishingContext.path(for: URL(string: target)!)
        #expect(output == "<a href=\"\(expectedPath)\">\(description)</a>")
    }

    @Test("Page Target Test")
    func target() async throws {
        let page = TestSubsitePage()
        let element = Link("This is a test", target: page).linkStyle(.button)
        let output = element.markupString()
        #expect(output == "<a href=\"\(page.path)\" class=\"btn btn-primary\">This is a test</a>")
    }

    @Test("Page Content Test")
    func content() async throws {
        let page = TestPage()
        let element = LinkGroup(target: page) {
            "MORE "
            Text("CONTENT")
        }
        let output = element.markupString()

        #expect(output == "<a href=\"\(page.path)\" class=\"link-plain d-inline-block\">MORE <p>CONTENT</p></a>")
    }
}
