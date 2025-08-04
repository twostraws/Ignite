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
class MetaTagTests: IgniteTestSuite {
    @Test("Meta tag with type enum and content a URL")
    func withEnumAndContentURL() async throws {
        let element = MetaTag(.twitterDomain, content: URL(string: "https://example.com?s=searching#target")!)
        let output = element.render()

        #expect(output.string == "<meta name=\"twitter:domain\" content=\"https://example.com?s=searching#target\" />")
    }

    @Test("Meta tag with name and content both strings")
    func withNameAndContentBothStrings() async throws {
        let element = MetaTag(name: "tagname", content: "my content")
        let output = element.render()

        #expect(output.string == "<meta name=\"tagname\" content=\"my content\" />")
    }

    @Test("Meta tag with property and content both strings")
    func withPropertyAndContentBothStrings() async throws {
        let element = MetaTag(property: "unique", content: "my value")
        let output = element.render()

        #expect(output.string == "<meta property=\"unique\" content=\"my value\" />")
    }

    @Test("Meta tag with character set only")
    func withCharacterSet() async throws {
        let element = MetaTag(characterSet: "UTF-16")
        let output = element.render()

        #expect(output.string == "<meta charset=\"UTF-16\" />")
    }

    func metaTagCoreFieldsMatch(_ actual: MetaTag, _ expected: MetaTag) -> Bool {
        let actualCustomAttributes = actual.attributes.customAttributes
        let expectedCustomAttributes = expected.attributes.customAttributes
        let actualDict = Dictionary(uniqueKeysWithValues: actualCustomAttributes.map { ($0.name, $0.value) })
        let expectedDict = Dictionary(uniqueKeysWithValues: expectedCustomAttributes.map { ($0.name, $0.value) })
        let keysToCompare = ["name", "property", "content", "charset", "http-equiv"]

        for key in keysToCompare where actualDict[key] != expectedDict[key] {
            return false
        }

        return true
    }

    @Test("Social sharing tags with no image, description, or www")
    func socialSharingTagsWithNoImageDescriptionOrWWW() async throws {
        let page = PageMetadata(
            title: "My Page Title",
            description: "",
            url: URL(string: "https://example.com")!
        )

        publishingContext.environment.page = page

        let tags = MetaTag.socialSharingTags()

        let expectedTags: [MetaTag] = [
            MetaTag(.openGraphSiteName, content: "My Test Site"),
            MetaTag(.openGraphTitle, content: "My Page Title"),
            MetaTag(.twitterTitle, content: "My Page Title"),
            MetaTag(.openGraphURL, content: "https://example.com"),
            MetaTag(.twitterDomain, content: "example.com"),
            MetaTag(.twitterCard, content: "summary_large_image"),
            MetaTag(.twitterDoNotTrack, content: "on")
        ]

        #expect(tags.count == expectedTags.count)

        for (actual, expected) in zip(tags, expectedTags) {
            #expect(metaTagCoreFieldsMatch(actual, expected))
        }
    }

    @Test("Social sharing tags with image, description, and www")
    func socialSharingTagsWithImageDescriptionAndWWW() async throws {
        let page = PageMetadata(
            title: "My Page Title",
            description: "describing the page",
            url: URL(string: "https://www.example.com")!,
            image: URL(string: "https://example.com/image.png")!
        )

        publishingContext.environment.page = page

        let actualTags = MetaTag.socialSharingTags()

        let expectedTags: [MetaTag] = [
            MetaTag(.openGraphSiteName, content: "My Test Site"),
            MetaTag(.openGraphImage, content: "https://example.com/image.png"),
            MetaTag(.twitterImage, content: "https://example.com/image.png"),
            MetaTag(.openGraphTitle, content: "My Page Title"),
            MetaTag(.twitterTitle, content: "My Page Title"),
            MetaTag(.openGraphDescription, content: "describing the page"),
            MetaTag(.twitterDescription, content: "describing the page"),
            MetaTag(.openGraphURL, content: "https://www.example.com"),
            MetaTag(.twitterDomain, content: "example.com"),
            MetaTag(.twitterCard, content: "summary_large_image"),
            MetaTag(.twitterDoNotTrack, content: "on")
        ]

        #expect(actualTags.count == expectedTags.count)

        for (actual, expected) in zip(actualTags, expectedTags) {
            #expect(metaTagCoreFieldsMatch(actual, expected))
        }
    }
}
