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
class MetaLinkTests: IgniteSuite {
    @Test("Test with href string and rel string")
    func hrefStringAndRelString() async throws {
        let element = MetaLink(href: "https://www.example.com", rel: "canonical")
        let output = element.render()

        #expect(output == "<link href=\"https://www.example.com\" rel=\"canonical\" />")
    }

    @Test("Test href URL and rel string")
    func hrefURLAndRelString() async throws {
        let url = try #require(URL(string: "https://www.example.com"))
        let element = MetaLink(href: url, rel: "canonical")
        let output = element.render()

        #expect(output == "<link href=\"https://www.example.com\" rel=\"canonical\" />")
    }

    @Test("Test href string and rel Link.Relationship")
    func hrefStringAndRelRelationship() async throws {
        let element = MetaLink(href: "https://www.example.com", rel: .external)
        let output = element.render()

        #expect(output == "<link href=\"https://www.example.com\" rel=\"external\" />")
    }

    @Test("Test href URL and rel Link.Relationship")
    func hrefURLAndRelRelationship() async throws {
        let url = try #require(URL(string: "https://www.example.com"))
        let element = MetaLink(href: url, rel: .alternate)
        let output = element.render()

        #expect(output == "<link href=\"https://www.example.com\" rel=\"alternate\" />")
    }
}
