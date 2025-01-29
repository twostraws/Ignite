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
@MainActor class LinkTests: IgniteSuite {
    @Test("String Target Test", arguments: ["/"], ["Go Home"])
    func target(for target: String, description: String) async throws {
        let element = Link(description, target: target)
        let output = element.render()
        let expectedPath = site.url.appending(path: target).decodedPath

        #expect(output == """
        <a href="\(expectedPath)" \
        class="link-underline link-underline-opacity-100 \
        link-underline-opacity-100-hover">\
        \(description)\
        </a>
        """)
    }

    @Test("Page Target Test")
    func target() async throws {
        let page = TestLayout()
        let element = Link("This is a test", target: page).linkStyle(.button)
        let output = element.render()
        #expect(output == "<a href=\"\(page.path)\" class=\"btn btn-primary\">This is a test</a>")
    }

    @Test("Page Content Test")
    func content() async throws {
        let page = TestLayout()
        let element = Link(target: page) {
            "MORE "
            Text("CONTENT")
        }
        let output = element.render()

        #expect(output == """
        <a href="\(page.path)" \
        class="link-plain link-underline link-underline-opacity-100 \
        link-underline-opacity-100-hover">\
        MORE <p>CONTENT</p>\
        </a>
        """)
    }

    @Test("Link Warning Role Test")
    func warningRoleLink() async throws {
        let page = TestLayout()
        let element = Link("Link with warning role.", target: page).role(.warning)
        let output = element.render()

        #expect(output == """
        <a href="\(page.path)" \
        class="link-underline link-underline-opacity-100 \
        link-underline-opacity-100-hover link-warning\">\
        Link with warning role.\
        </a>
        """)
    }
}
