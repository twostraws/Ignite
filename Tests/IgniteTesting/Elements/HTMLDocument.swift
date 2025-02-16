//
//  HTMLDocument.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `HTMLDocument` element.
@Suite("HTMLDocument Tests")
@MainActor
struct HTMLDocumentTests {
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Starts with doctype html")
    func containsHTMLDoctype() {
        let sut = HTMLDocument {}
        let output = sut.render()
        #expect(output.hasPrefix("<!doctype html>"))
    }

    @Test("Contains html tag")
    func containsHTMLTag() {
        let sut = HTMLDocument {}
        let output = sut.render()
        #expect(nil != output.htmlTagWithCloseTag("html"))
    }

    @Test("theme attribute is `auto`")
    func theme_is_auto() throws {
        let sut = HTMLDocument {}
        let output = sut.render()

        let theme = try #require(output.htmlTagWithCloseTag("html")?.attributes
            .htmlAttribute(named: "data-bs-theme")
        )

        #expect(theme == "auto")
    }

    @Test("lang attribute defaults to en")
    func language_attribute_defaults_to_en() throws {
        let sut = HTMLDocument {}
        let output = sut.render()

        let language = try #require(output.htmlTagWithCloseTag("html")?.attributes
            .htmlAttribute(named: "lang")
        )

        #expect(language == "en")
    }

    @Test("lang attribute is taken from language property", arguments: Language.allCases)
    func language_property_determines_lang_attribute(_ language: Language) throws {
        let sut = HTMLDocument(language: language) {}
        let output = sut.render()

        let langAttribute = try #require(output.htmlTagWithCloseTag("html")?.attributes
            .htmlAttribute(named: "lang")
        )

        #expect(langAttribute == language.rawValue)
    }

    @Test("If contents are empty then html tag is empty")
    func contents_are_empty_by_default() throws {
        let sut = HTMLDocument {}
        let output = sut.render()

        let htmlContents = try #require(output.htmlTagWithCloseTag("html")?.contents)

        #expect(htmlContents.isEmpty)
    }

    @Test("places output of contents into contents of html tag")
    func html_tag_contents_are_taken_from_contents_property() async throws {
        let body = Body { "Hello World" }
        let sut = HTMLDocument { body }

        let expected = body.render()

        let htmlContents = try #require(sut.render().htmlTagWithCloseTag("html")?.contents)

        #expect(htmlContents == expected)
    }
}
