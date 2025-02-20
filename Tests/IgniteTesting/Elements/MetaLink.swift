//
//  MetaLink.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `MetaLink` element.
@Suite("MetaLink Tests")
@MainActor
class MetaLinkTests: IgniteTestSuite {
    @Test("href string and rel string")
    func hrefStringAndRelString() async throws {
        let element = MetaLink(href: "https://www.example.com", rel: "canonical")
        let output = element.render()

        #expect(output == "<link href=\"https://www.example.com\" rel=\"canonical\" />")
    }

    @Test("href URL and rel string")
    func hrefURLAndRelString() async throws {
        let url = try #require(URL(string: "https://www.example.com"))
        let element = MetaLink(href: url, rel: "canonical")
        let output = element.render()

        #expect(output == "<link href=\"https://www.example.com\" rel=\"canonical\" />")
    }

    @Test("href string and rel Link.Relationship")
    func hrefStringAndRelRelationship() async throws {
        let element = MetaLink(href: "https://www.example.com", rel: .external)
        let output = element.render()

        #expect(output == "<link href=\"https://www.example.com\" rel=\"external\" />")
    }

    @Test("href URL and rel Link.Relationship")
    func hrefURLAndRelRelationship() async throws {
        let url = try #require(URL(string: "https://www.example.com"))
        let element = MetaLink(href: url, rel: .alternate)
        let output = element.render()

        #expect(output == "<link href=\"https://www.example.com\" rel=\"alternate\" />")
    }

    @Test("Highlighting meta tags are sorted")
    func highlighterThemesAreSorted() async throws {
        let links = MetaLink.highlighterThemeMetaLinks(for: [.xcodeDark, .githubDark, .twilight])
        let output = links.render()

        #expect(output == """
        <link href=\"/css/prism-github-dark.css\" rel=\"stylesheet\" data-highlight-theme=\"github-dark\" />\
        <link href=\"/css/prism-twilight.css\" rel=\"stylesheet\" data-highlight-theme=\"twilight\" />\
        <link href=\"/css/prism-xcode-dark.css\" rel=\"stylesheet\" data-highlight-theme=\"xcode-dark\" />
        """)
    }
}
