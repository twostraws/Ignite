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

    @Test("Meta tag with name an enum and content a URL")
    func withNameStringAndContentURL() async throws {
        let element = MetaTag(name: .twitterDomain, content: URL(string: "https://example.com?s=searching#target")!)

        let output = element.render()

        #expect(output == "<meta content=\"https://example.com?s=searching#target\" name=\"twitter:domain\" />")
    }

    @Test("Meta tag with property and content both strings")
    func withPropertyAndContentBothStrings() async throws {
        let element = MetaTag(property: "unique", content: "my value")

        let output = element.render()

        #expect(output == "<meta content=\"my value\" property=\"unique\" />")
    }

    @Test("Meta tag with property an enum and content as URL")
    func withPropertyStringAndContentURL() async throws {
        let element = MetaTag(property: .openGraphURL, content: URL(string: "https://example.com?s=searching#target")!)

        let output = element.render()

        #expect(output == "<meta content=\"https://example.com?s=searching#target\" property=\"og:url\" />")
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
            MetaTag(property: .openGraphSiteName, content: "My Test Site"),
            MetaTag(property: .openGraphTitle, content: "My Page Title"),
            MetaTag(name: .twitterTitle, content: "My Page Title"),
            MetaTag(property: .openGraphURL, content: "https://example.com"),
            MetaTag(name: .twitterDomain, content: "example.com"),
            MetaTag(name: .twitterCard, content: "summary_large_image"),
            MetaTag(name: .twitterDoNotTrack, content: "on")
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
            MetaTag(property: .openGraphSiteName, content: "My Test Site"),
            MetaTag(property: .openGraphImage, content: "https://example.com/image.png"),
            MetaTag(name: .twitterImage, content: "https://example.com/image.png"),
            MetaTag(property: .openGraphTitle, content: "My Page Title"),
            MetaTag(name: .twitterTitle, content: "My Page Title"),
            MetaTag(property: .openGraphDescription, content: "describing the page"),
            MetaTag(name: .twitterDescription, content: "describing the page"),
            MetaTag(property: .openGraphURL, content: "https://www.example.com"),
            MetaTag(name: .twitterDomain, content: "example.com"),
            MetaTag(name: .twitterCard, content: "summary_large_image"),
            MetaTag(name: .twitterDoNotTrack, content: "on")
        ]

        #expect(actualTags.count == expectedTags.count)

        for (actual, expected) in zip(actualTags, expectedTags) {
            #expect(metaTagCoreFieldsMatch(actual, expected))
        }
    }
}
