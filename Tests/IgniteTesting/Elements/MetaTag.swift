//
//  MetaTag.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `MetaTag` element.
@Suite("MetaTag Tests")
@MainActor
struct MetaTagTests {
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    @Test("Meta tag with name and content both strings")
    func withNameAndContentBothStrings() async throws {
        let element = MetaTag(name: "tagname", content: "my content")

        let output = element.render()

        #expect(output == "<meta content=\"my content\" name=\"tagname\" />")
    }

    @Test("Meta tag with name a string and content a URL")
    func withNameStringAndContentURL() async throws {
        let element = MetaTag(name: "tagname", content: URL(string: "https://example.com?s=searching#target")!)

        let output = element.render()

        #expect(output == "<meta content=\"https://example.com?s=searching#target\" name=\"tagname\" />")
    }

    @Test("Meta tag with property and content both strings")
    func withPropertyAndContentBothStrings() async throws {
        let element = MetaTag(property: "unique", content: "my value")

        let output = element.render()

        #expect(output == "<meta content=\"my value\" property=\"unique\" />")
    }

    @Test("Meta tag with property a string and content as URL")
    func withPropertyStringAndContentURL() async throws {
        let element = MetaTag(property: "different", content: URL(string: "https://example.com?s=searching#target")!)

        let output = element.render()

        #expect(output == "<meta content=\"https://example.com?s=searching#target\" property=\"different\" />")
    }

    @Test("Meta tag with character set only")
    func withCharacterSet() async throws {
        let element = MetaTag(characterSet: "UTF-16")

        let output = element.render()

        #expect(output == "<meta charset=\"UTF-16\" />")
    }

    func metaTagCoreFieldsMatch(_ actual: MetaTag, _ expected: MetaTag) -> Bool {
        actual.name == expected.name && actual.content == expected.content && actual.charset == expected.charset
    }

    @Test("Social sharing tags with no image, description, or www")
    func socialSharingTagsWithNoImageDescriptionOrWWW() async throws {
        let page = Page(
            title: "My Page Title",
            description: "",
            url: URL(string: "https://example.com")!,
            body: Text("not much contents")
        )

        let tags = MetaTag.socialSharingTags(for: page)

        let expectedTags: [MetaTag] = [
            MetaTag(property: "og:site_name", content: "My Test Site"),
            MetaTag(property: "og:title", content: "My Page Title"),
            MetaTag(property: "twitter:title", content: "My Page Title"),
            MetaTag(property: "og:url", content: "https://example.com"),
            MetaTag(property: "twitter:domain", content: "example.com"),
            MetaTag(property: "twitter:card", content: "summary_large_image"),
            MetaTag(property: "twitter:dnt", content: "on")
        ]

        #expect(tags.count == expectedTags.count)

        for (actual, expected) in zip(tags, expectedTags) {
            #expect(metaTagCoreFieldsMatch(actual, expected))
        }
    }

    @Test("Social sharing tags with image, description, and www")
    func socialSharingTagsWithImageDescriptionAndWWW() async throws {
        let page = Page(
            title: "My Page Title",
            description: "describing the page",
            url: URL(string: "https://www.example.com")!,
            image: URL(string: "https://example.com/image.png")!,
            body: Text("not much contents")
        )

        let actualTags = MetaTag.socialSharingTags(for: page)

        let expectedTags: [MetaTag] = [
            MetaTag(property: "og:site_name", content: "My Test Site"),
            MetaTag(property: "og:image", content: "https://example.com/image.png"),
            MetaTag(property: "twitter:image", content: "https://example.com/image.png"),
            MetaTag(property: "og:title", content: "My Page Title"),
            MetaTag(property: "twitter:title", content: "My Page Title"),
            MetaTag(property: "og:description", content: "describing the page"),
            MetaTag(property: "twitter:description", content: "describing the page"),
            MetaTag(property: "og:url", content: "https://www.example.com"),
            MetaTag(property: "twitter:domain", content: "example.com"),
            MetaTag(property: "twitter:card", content: "summary_large_image"),
            MetaTag(property: "twitter:dnt", content: "on")
        ]

        #expect(actualTags.count == expectedTags.count)

        for (actual, expected) in zip(actualTags, expectedTags) {
            #expect(metaTagCoreFieldsMatch(actual, expected))
        }
    }
}
