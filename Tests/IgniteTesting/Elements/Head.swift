//
//  HTMLHead.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `HTMLHead` element.
@Suite("HTMLHead Tests")
@MainActor
class HTMLHeadTests: IgniteTestSuite {
    @Test("Defaults to empty head tag")
    func default_is_empty_head_tag() throws {
        let sut = Head().standardHeadersDisabled()
        let output = sut.markupString()

        let (attributes, contents) = try #require(output.htmlTagWithCloseTag("head"))

        #expect(contents.isEmpty)
        #expect(attributes.isEmpty)
    }

    @Test("Output contains items passed in on init")
    func outputs_items_passed_on_init() throws {
        let sut = Head {
            Title("Hello, World")
            Script(file: "../script.js")
            MetaTag(.openGraphTitle, content: "hello")
        }
        .standardHeadersDisabled()

        let output = sut.markupString()
        let contents = try #require(output.htmlTagWithCloseTag("head")?.contents)

        let exampleHeaderItems: [any HeadElement] = [
            Title("Hello, World"),
            Script(file: "../script.js"),
            MetaTag(.openGraphTitle, content: "hello")
        ]

        for item in exampleHeaderItems {
            #expect(contents.contains(item.markupString()))
        }
    }

    @Test("Output contains standard headers for page passed in on init")
    func output_contains_standard_headers_for_page() throws {
        let sut = Head()
        let expected = Head.standardHeaders().map { $0.markupString() }.joined()

        let output = sut.markupString()

        #expect(output.contains(expected))
    }

    @Test("Output contains soccial sharing tags for page passed in on init")
    func output_contains_social_sharing_tags() throws {
        let sut = Head()
        let expected = MetaTag.socialSharingTags().map { $0.markupString() }.joined()

        let output = sut.markupString()

        #expect(output.contains(expected))
    }

    @Test("Output contains any additional items passed in on init")
    func output_contains_additional_items() throws {
        let additionalItem = Script(file: "somefile.js")
        let sut = Head { additionalItem }
        let expected = additionalItem.render().string

        let output = sut.markupString()

        #expect(output.contains(expected))
    }
}
