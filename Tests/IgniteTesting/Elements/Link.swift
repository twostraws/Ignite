//
// Link.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

enum LinkDestination: Sendable {
    case standard
    case subsite

    var site: any Site {
        switch self {
        case .standard:
            TestSite()
        case .subsite:
            TestSubsite()
        }
    }

    var page: any StaticPage {
        switch self {
        case .standard:
            TestPage()
        case .subsite:
            TestSubsitePage()
        }
    }
}

/// Tests for the `title` element.
@Suite("Link Tests")
class LinkTests: IgniteTestSuite {
    static let destinations: [LinkDestination] = [.standard, .subsite]

    @Test("String Target", .publishingContext(), arguments: [(target: "/", description: "Go Home")], TestPublishingSite.standardAndSubsite)
    func target(for link: (target: String, description: String), for siteCase: TestPublishingSite) async throws {
        let site = siteCase.site

        try withPublishingContext(for: site) { context in
            let element = Link(link.description, target: link.target)
            let output = element.markupString()
            let expectedPath = context.linkPath(for: URL(string: link.target)!)

            #expect(output == "<a href=\"\(expectedPath)\">\(link.description)</a>")
        }
    }

    @Test("Page Target", .publishingContext(), arguments: destinations)
    func target(for destination: LinkDestination) async throws {
        let page = destination.page
        let site = destination.site

        try withPublishingContext(for: site) { context in
            let element = Link("This is a test", target: page).linkStyle(.button)
            let output = element.markupString()
            let expectedPath = context.linkPath(for: URL(string: page.path)!)

            #expect(output == "<a href=\"\(expectedPath)\" class=\"btn btn-primary\">This is a test</a>")
        }
    }

    @Test("Page Content", .publishingContext(), arguments: destinations)
    func content(for destination: LinkDestination) async throws {
        let page = destination.page
        let site = destination.site

        try withPublishingContext(for: site) { context in
            let element = LinkGroup(target: page) {
                "MORE "
                Text("CONTENT")
            }
            let output = element.markupString()
            let expectedPath = context.linkPath(for: URL(string: page.path)!)

            #expect(output == "<a href=\"\(expectedPath)\" class=\"link-plain d-inline-block\">MORE <p>CONTENT</p></a>")
        }
    }

    @Test("Link Warning Role", .publishingContext(), arguments: destinations)
    func warningRoleLink(for destination: LinkDestination) async throws {
        let page = destination.page
        let site = destination.site

        try withPublishingContext(for: site) { context in
            let element = Link("Link with warning role.", target: page).role(.warning)
            let output = element.markupString()
            let expectedPath = context.linkPath(for: URL(string: page.path)!)

            #expect(output == "<a href=\"\(expectedPath)\" class=\"link-warning\">Link with warning role.</a>")
        }
    }

    @Test("LinkGroup with string target", .publishingContext())
    func linkGroupWithStringTarget() async throws {
        let element = LinkGroup(target: "/about") {
            Text("About Us")
        }
        let output = element.markupString()
        #expect(output.contains("href=\"/about/\""))
        #expect(output.contains("About Us"))
        #expect(output.contains("link-plain"))
    }

    @Test("LinkGroup with target modifier", .publishingContext(), arguments: destinations)
    func linkGroupWithTargetModifier(destination: LinkDestination) async throws {
        let page = destination.page
        let site = destination.site

        let output = try withPublishingContext(for: site) { _ in
            let element = LinkGroup(target: page) {
                Text("Click here")
            }.target(.blank)
            return element.markupString()
        }

        #expect(output.contains("target=\"_blank\""))
    }

    @Test("LinkGroup with relationship", .publishingContext(), arguments: destinations)
    func linkGroupWithRelationship(destination: LinkDestination) async throws {
        let page = destination.page
        let site = destination.site

        let output = try withPublishingContext(for: site) { _ in
            let element = LinkGroup(target: page) {
                Text("External")
            }.relationship(.noFollow)
            return element.markupString()
        }

        #expect(output.contains("rel=\"nofollow\""))
    }
}
