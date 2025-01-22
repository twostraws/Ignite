//
// Link.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `title` element.
@Suite("Link Tests")
@MainActor struct SubsiteLinkTests {
    init() {
        try! PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("String Target Test", arguments: ["/"])
    func stringTarget(linkTarget: String) async throws {
        let element = Link("Go Home", target: linkTarget)
        let output = element.render()

        #expect(
            output == """
            <a href="\(linkTarget)\" \
            class="link-underline link-underline-opacity-100 \
            link-underline-opacity-100-hover">\
            Go Home\
            </a>
            """
        )
    }

    @Test("Page Target Test")
    func pageTarget() async throws {
        let element = Link("This is a test", target: TestPage())
            .linkStyle(.button)
        let output = element.render()

        #expect(
            output
                == "<a href=\"/test-page\" class=\"btn btn-primary\">This is a test</a>"
        )
    }

    @Test("Page Content Test")
    func pageContent() async throws {
        let element = Link(
            target: TestPage(),
            content: {
                "MORE "
                Text("CONTENT")
            })
        let output = element.render()

        #expect(
            output == """
            <a href="/test-page" \
            class="link-plain link-underline link-underline-opacity-100 \
            link-underline-opacity-100-hover">\
            MORE <p>CONTENT</p>\
            </a>
            """
        )
    }
}
