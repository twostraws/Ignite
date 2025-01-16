//
// SubsiteLink.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `title` element.
@Suite("Subscribe Link Tests")
@MainActor struct SubsiteLinkTests {
    let publishingContext = ElementTest.publishingSubsiteContext

    @Test("String Target Test", arguments: ["/"])
    func test_string_target(linkTarget: String) async throws {
        let element = Link("Go Home", target: linkTarget)
        let output = element.render(context: publishingContext)

        #expect(
            output == """
            <a href="/subsite\(linkTarget)\" class="link-underline-opacity-100 link-underline-opacity-100-hover">\
            Go Home\
            </a>
            """
        )
    }

    @Test("Page Target Test")
    func test_page_target() async throws {
        let element = Link("This is a test", target: TestPage()).linkStyle(
            .button)
        let output = element.render(context: publishingContext)

        #expect(
            output
                == "<a href=\"/subsite/test-page\" class=\"btn btn-primary\">This is a test</a>"
        )
    }

    @Test("Page Content Test")
    func test_page_content() async throws {
        let element = Link(
            target: TestPage(),
            content: {
                "MORE "
                Text("CONTENT")
            })
        let output = element.render(context: publishingContext)

        #expect(
            output == """
            <a href="/subsite/test-page" class="link-plain link-underline link-underline-opacity-100 link-underline-opacity-100-hover">\
            MORE <p>CONTENT</p>\
            </a>
            """
        )
    }
}
