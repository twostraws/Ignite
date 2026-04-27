//
// JSONFeedGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `JSONFeedGenerator` type.
@Suite("JSONFeedGenerator Tests")
@MainActor
struct JSONFeedGeneratorTests {

    // MARK: - Helpers

    private func parseJSON(_ output: String) throws -> [String: Any] {
        let data = try #require(output.data(using: .utf8))
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        return json
    }

    private func makeArticle(
        title: String = "Example Title",
        description: String = "Example Description",
        text: String = "<p>Full article text</p>",
        path: String = "/articles/example",
        author: String? = nil,
        tags: String? = nil
    ) -> Article {
        var article = Article()
        article.title = title
        article.description = description
        article.text = text
        article.path = path
        if let author {
            article.metadata["author"] = author
        }
        if let tags {
            article.metadata["tags"] = tags
        }
        return article
    }

    // MARK: - Tests

    @Test("Golden path: single article produces correct JSON Feed structure")
    func goldenPath() throws {
        let site = TestSite()
        let config = site.feedConfiguration!
        let article = makeArticle()

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        #expect(json["version"] as? String == "https://jsonfeed.org/version/1.1")
        #expect(json["title"] as? String == "My Test Site")
        #expect(json["home_page_url"] as? String == "https://www.example.com")

        let feedURL = json["feed_url"] as? String
        let jsonPath = config.paths[.json] ?? "/feed.json"
        #expect(feedURL?.contains(jsonPath) == true)

        let items = try #require(json["items"] as? [[String: Any]])
        #expect(items.count == 1)

        let item = items[0]
        #expect(item["title"] as? String == "Example Title")
        #expect(item["summary"] as? String == "Example Description")
        #expect(item["id"] as? String == item["url"] as? String)
    }

    @Test("Description-only mode: items have summary but no content_html")
    func descriptionOnlyMode() throws {
        let site = TestSite()
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 20)!
        let article = makeArticle()

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        let items = try #require(json["items"] as? [[String: Any]])
        let item = items[0]
        #expect(item["summary"] as? String == "Example Description")
        #expect(item["content_html"] == nil)
        // JSON Feed v1.1 requires content_html or content_text — descriptionOnly uses content_text
        #expect(item["content_text"] as? String == "Example Description")
    }

    @Test("Full-content mode: items include content_html")
    func fullContentMode() throws {
        let site = TestSite()
        let config = FeedConfiguration(mode: .full, contentCount: 20)!
        let article = makeArticle(text: "<p>Full body content</p>")

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        let items = try #require(json["items"] as? [[String: Any]])
        let item = items[0]
        #expect(item["content_html"] as? String != nil)
        #expect(item["summary"] as? String == "Example Description")
    }

    @Test("Output is valid JSON")
    func jsonValidity() throws {
        let site = TestSite()
        let config = site.feedConfiguration!
        let article = makeArticle()

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()

        let data = try #require(output.data(using: .utf8))
        let parsed = try JSONSerialization.jsonObject(with: data)
        #expect(parsed is [String: Any])
    }

    @Test("Multiple articles: contentCount limits items")
    func multipleArticlesContentCount() throws {
        let site = TestSite()
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 2)!

        let articles = (1...5).map { i in
            makeArticle(title: "Article \(i)", path: "/articles/\(i)")
        }

        let generator = JSONFeedGenerator(config: config, site: site, content: articles)
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        let items = try #require(json["items"] as? [[String: Any]])
        #expect(items.count == 2)
        #expect(items[0]["title"] as? String == "Article 1")
        #expect(items[1]["title"] as? String == "Article 2")
    }

    @Test("Author handling: article author overrides site author")
    func authorOverride() throws {
        let site = TestSite()
        let config = site.feedConfiguration!
        let article = makeArticle(author: "Article Author")

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        let items = try #require(json["items"] as? [[String: Any]])
        let item = items[0]
        let itemAuthors = try #require(item["authors"] as? [[String: Any]])
        #expect(itemAuthors[0]["name"] as? String == "Article Author")
    }

    @Test("Author handling: omit authors when both site and article author are empty")
    func authorOmittedWhenEmpty() throws {
        let site = TestSite() // site.author is ""
        let config = site.feedConfiguration!
        let article = makeArticle() // no article author

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        // Top-level authors should be nil when site author is empty
        #expect(json["authors"] == nil)

        // Item-level authors should be nil when both are empty
        let items = try #require(json["items"] as? [[String: Any]])
        let item = items[0]
        #expect(item["authors"] == nil)
    }

    @Test("Tags: present as array of strings in items")
    func tagsPresent() throws {
        let site = TestSite()
        let config = site.feedConfiguration!
        let article = makeArticle(tags: "swift, testing, ignite")

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        let items = try #require(json["items"] as? [[String: Any]])
        let item = items[0]
        let tags = try #require(item["tags"] as? [String])
        #expect(tags.contains("swift"))
        #expect(tags.contains("testing"))
        #expect(tags.contains("ignite"))
    }

    @Test("Feed image: icon and favicon present when image configured")
    func feedImageIcon() throws {
        let site = TestSite() // has feedConfiguration with image
        let config = site.feedConfiguration!
        let article = makeArticle()

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        #expect(json["icon"] as? String == "path/to/image.png")
        #expect(json["favicon"] as? String == "path/to/image.png")
    }

    @Test("Language: matches site language")
    func languagePresent() throws {
        let site = TestSite()
        let config = site.feedConfiguration!
        let article = makeArticle()

        let generator = JSONFeedGenerator(config: config, site: site, content: [article])
        let output = generator.generateFeed()
        let json = try parseJSON(output)

        #expect(json["language"] as? String == site.language.rawValue)
    }
}
