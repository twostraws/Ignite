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
class HTMLDocumentTests: IgniteTestSuite {
    @Test("Starts with doctype html")
    func containsHTMLDoctype() {
        let sut = PlainDocument(head: Head(), body: Body())
        let output = sut.markupString()
        #expect(output.hasPrefix("<!doctype html>"))
    }

    @Test("Contains html tag")
    func containsHTMLTag() {
        let sut = PlainDocument(head: Head(), body: Body())
        let output = sut.markupString()
        #expect(nil != output.htmlTagWithCloseTag("html"))
    }

    @Test("lang attribute defaults to en")
    func language_attribute_defaults_to_en() throws {
        let sut = PlainDocument(head: Head(), body: Body())
        let output = sut.markupString()

        let language = try #require(output.htmlTagWithCloseTag("html")?.attributes
            .htmlAttribute(named: "lang")
        )

        #expect(language == "en")
    }

    @Test("html tag includes data-light-theme attribute matching site light theme cssID")
    func html_includes_data_light_theme_attribute() throws {
        let sut = PlainDocument(head: Head(), body: Body())
        let output = sut.markupString()

        let lightTheme = try #require(output.htmlTagWithCloseTag("html")?.attributes
            .htmlAttribute(named: "data-light-theme")
        )

        #expect(lightTheme == "light")
    }

    @Test("html tag includes data-dark-theme attribute matching site dark theme cssID")
    func html_includes_data_dark_theme_attribute() throws {
        let sut = PlainDocument(head: Head(), body: Body())
        let output = sut.markupString()

        let darkTheme = try #require(output.htmlTagWithCloseTag("html")?.attributes
            .htmlAttribute(named: "data-dark-theme")
        )

        #expect(darkTheme == "dark")
    }

    @Test("lang attribute is taken from language property", arguments: Language.allCases)
    func language_property_determines_lang_attribute(_ language: Language) throws {

        /// New TestSite initialized with the test language.
        var site = TestSite()
        site.language = language

        /// Create an environment and initialize it with the set language. 
        let values = EnvironmentValues(
            sourceDirectory: publishingContext.sourceDirectory,
            site: site,
            allContent: publishingContext.allContent,
            pageMetadata: publishingContext.environment.page,
            pageContent: publishingContext.site.homePage)

        /// Initialize Document with the TestSite language set above.
        let sut = publishingContext.withEnvironment(values) {
            PlainDocument(head: Head(), body: Body())
        }

        let output = sut.markupString()

        let langAttribute = try #require(output.htmlTagWithCloseTag("html")?.attributes
            .htmlAttribute(named: "lang")
        )

        #expect(langAttribute == language.rawValue)
    }
}
