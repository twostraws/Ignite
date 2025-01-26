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
    static let sites: [any Site] = [TestSite(), TestSubsite()]
    static let pages: [any StaticLayout] = [TestLayout(), TestSubsiteLayout()]

    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("String Target Test", arguments: [(target: "/", description: "Go Home")], await Self.sites)
    func target(for link: (target: String, description: String), for site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Link(link.description, target: link.target)
        let output = element.render()
        let expectedPath = site.url.path == "/" ? link.target : "\(site.url.path)\(link.target)"

        #expect(
            output == """
            <a href="\(expectedPath)" \
            class="link-underline link-underline-opacity-100 \
            link-underline-opacity-100-hover">\
            \(link.description)\
            </a>
            """
        )
    }

    @Test("Page Target Test", arguments: zip(await pages, await Self.sites))
    func target(for page: any StaticLayout, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Link("This is a test", target: page).linkStyle(.button)
        let output = element.render()

        let expectedPath = site.url.pathComponents.count <= 1 ?
            "/test-layout" :
            "\(site.url.path)/test-subsite-layout"

        #expect(output == "<a href=\"\(expectedPath)\" class=\"btn btn-primary\">This is a test</a>")
    }

    @Test("Page Content Test", arguments: zip(await pages, await Self.sites))
    func content(for page: any StaticLayout, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Link(
            target: page,
            content: {
                "MORE "
                Text("CONTENT")
            })
        let output = element.render()

        let expectedPath = site.url.pathComponents.count <= 1 ?
            "/test-layout" :
            "\(site.url.path)/test-subsite-layout"

        #expect(
            output == """
            <a href="\(expectedPath)" \
            class="link-plain link-underline link-underline-opacity-100 \
            link-underline-opacity-100-hover">\
            MORE <p>CONTENT</p>\
            </a>
            """
        )
    }

    @Test("Link Warning Role Test", arguments: zip(await pages, await Self.sites))
    func warningRoleLink(for page: any StaticLayout, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Link("Link with warning role.", target: page).role(.warning)
        let output = element.render()
        let expectedPath = site.url.pathComponents.count <= 1 ?
        "/test-layout" :
        "\(site.url.path)/test-subsite-layout"

        #expect(
            output == """
            <a href="\(expectedPath)" \
            class="link-underline link-underline-opacity-100 \
            link-underline-opacity-100-hover link-warning\">\
            Link with warning role.\
            </a>
            """
        )
    }
}
