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
@MainActor class LinkTests: IgniteTestSuite {
    static let sites: [any Site] = [TestSite(), TestSubsite()]
    static let pages: [any StaticPage] = [TestPage(), TestSubsitePage()]

    @Test("String Target", arguments: [(target: "/", description: "Go Home")], await Self.sites)
    func target(for link: (target: String, description: String), for site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Link(link.description, target: link.target)
        let output = element.render()
        let expectedPath = PublishingContext.shared.path(for: URL(string: link.target)!)

        #expect(output == "<a href=\"\(expectedPath)\">\(link.description)</a>")
    }

    @Test("Page Target", arguments: zip(await pages, await Self.sites))
    func target(for page: any StaticPage, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Link("This is a test", target: page).linkStyle(.button)
        let output = element.render()

        let expectedPath = PublishingContext.shared.path(for: URL(string: page.path)!)

        #expect(output == "<a href=\"\(expectedPath)\" class=\"btn btn-primary\">This is a test</a>")
    }

    @Test("Page Content", arguments: zip(await pages, await Self.sites))
    func content(for page: any StaticPage, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Link(target: page) {
            "MORE "
            Text("CONTENT")
        }
        let output = element.render()

        let expectedPath = PublishingContext.shared.path(for: URL(string: page.path)!)

        #expect(output == "<a href=\"\(expectedPath)\" class=\"link-plain\">MORE <p>CONTENT</p></a>")
    }

    @Test("Link Warning Role", arguments: zip(await pages, await Self.sites))
    func warningRoleLink(for page: any StaticPage, site: any Site) async throws {
        try PublishingContext.initialize(for: site, from: #filePath)

        let element = Link("Link with warning role.", target: page).role(.warning)
        let output = element.render()
        let expectedPath = PublishingContext.shared.path(for: URL(string: page.path)!)

        #expect(output == "<a href=\"\(expectedPath)\" class=\"link-warning\">Link with warning role.</a>")
    }
}
