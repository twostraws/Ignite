//
//  Content.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `Content` type.
@Suite("Content Tests")
struct ContentTests {
    @Test("Empty Article() has default values", .publishingContext())
    func emptyArticle() async throws {
        let article = Article()
        #expect(article.title == "")
        #expect(article.description == "")
        #expect(article.path == "")
        #expect(article.text == "")
        #expect(article.hasAutomaticDate == false)
    }

    @Test("tags parses comma-separated metadata", .publishingContext())
    func tagsParsing() async throws {
        var article = Article()
        article.metadata["tags"] = "swift, ignite, web"

        let tags = article.tags
        #expect(tags == ["swift", "ignite", "web"])
    }

    @Test("tags returns nil when no tags metadata", .publishingContext())
    func tagsNilWhenMissing() async throws {
        let article = Article()
        #expect(article.tags == nil)
    }

    @Test("author returns metadata author value", .publishingContext())
    func author() async throws {
        var article = Article()
        article.metadata["author"] = "Paul Hudson"

        #expect(article.author == "Paul Hudson")
    }

    @Test("author returns nil when not set", .publishingContext())
    func authorNilWhenMissing() async throws {
        let article = Article()
        #expect(article.author == nil)
    }

    @Test("subtitle returns metadata subtitle value", .publishingContext())
    func subtitle() async throws {
        var article = Article()
        article.metadata["subtitle"] = "A great subtitle"

        #expect(article.subtitle == "A great subtitle")
    }

    @Test("image returns metadata image value", .publishingContext())
    func image() async throws {
        var article = Article()
        article.metadata["image"] = "/images/hero.jpg"

        #expect(article.image == "/images/hero.jpg")
    }

    @Test("imageDescription returns alt metadata or empty string", .publishingContext())
    func imageDescription() async throws {
        var article = Article()
        #expect(article.imageDescription == "")

        article.metadata["alt"] = "A scenic view"
        #expect(article.imageDescription == "A scenic view")
    }

    @Test("isPublished defaults to true", .publishingContext())
    func isPublishedDefault() async throws {
        let article = Article()
        #expect(article.isPublished == true)
    }

    @Test("isPublished respects false metadata", .publishingContext())
    func isPublishedFalse() async throws {
        var article = Article()
        article.metadata["published"] = "false"

        #expect(article.isPublished == false)
    }

    @Test("isPublished treats invalid string as true", .publishingContext())
    func isPublishedInvalid() async throws {
        var article = Article()
        article.metadata["published"] = "maybe"

        #expect(article.isPublished == true)
    }

    @Test("estimatedWordCount counts words using regex", .publishingContext())
    func estimatedWordCount() async throws {
        var article = Article()
        article.text = "Hello world this is a test"

        #expect(article.estimatedWordCount == 6)
    }

    @Test("estimatedWordCount counts hyphenated words as one", .publishingContext())
    func estimatedWordCountHyphenated() async throws {
        var article = Article()
        article.text = "This is a well-known fact"

        #expect(article.estimatedWordCount == 5)
    }

    @Test("estimatedReadingMinutes is ceil of word count divided by 250", .publishingContext())
    func estimatedReadingMinutes() async throws {
        var article = Article()
        article.text = Array(repeating: "word", count: 500).joined(separator: " ")

        #expect(article.estimatedReadingMinutes == 2)
    }

    @Test("estimatedReadingMinutes rounds up for partial minutes", .publishingContext())
    func estimatedReadingMinutesRoundsUp() async throws {
        var article = Article()
        article.text = Array(repeating: "word", count: 251).joined(separator: " ")

        #expect(article.estimatedReadingMinutes == 2)
    }

    @Test("estimatedReadingMinutes is 1 for short content", .publishingContext())
    func estimatedReadingMinutesShort() async throws {
        var article = Article()
        article.text = "Just a few words"

        #expect(article.estimatedReadingMinutes == 1)
    }

    @Test("Article.empty static property creates empty instance", .publishingContext())
    func emptyStatic() async throws {
        let article = Article.empty
        #expect(article.title == "")
        #expect(article.text == "")
    }
}
