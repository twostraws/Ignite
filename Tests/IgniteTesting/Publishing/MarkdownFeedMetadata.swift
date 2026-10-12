//
// MarkdownFeedMetadata.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import SwiftSoup
import Testing

@testable import Ignite

/// Loads Markdown through Article before exercising the actual feed generators.
@Suite("Markdown Feed Metadata Tests")
struct MarkdownFeedMetadataTests {
    @Test("Markdown text remains readable in feed text and HTML", .publishingContext(), arguments: [
        ("`a & b`", "a & b", "a &amp; b"),
        ("`Array<String>`", "Array<String>", "Array&lt;String&gt;"),
        ("`&lt;`", "&lt;", "&amp;lt;"),
        ("`let count = 3`", "let count = 3", "let count = 3"),
        ("Ordinary text", "Ordinary text", "Ordinary text"),
        (#"Use \<br/> literally."#, "Use <br/> literally.", "Use &lt;br/&gt; literally."),
        ("Literal &amp;lt;", "Literal &lt;", "Literal &amp;lt;"),
        ("Read &lt;strong&gt;literally&lt;/strong&gt;", "Read <strong>literally</strong>", "Read &lt;strong&gt;literally&lt;/strong&gt;")
    ], [FeedConfiguration.ContentMode.descriptionOnly, .full])
    func markdownFeedMetadata(sample: (String, String, String), mode: FeedConfiguration.ContentMode) throws {
        let (markdown, expected, encoded) = sample
        let article = try loadArticle("# \(markdown)\n\n\(markdown)")
        let site = TestSite()
        let config = try #require(FeedConfiguration(mode: mode, contentCount: 20))

        // Public article values still serve HTML consumers; only feed text is decoded.
        #expect(article.title == encoded)
        #expect(article.description == encoded)
        #expect(try SwiftSoup.parseBodyFragment(article.text).text() == expected)

        let rss = FeedGenerator(config: config, site: site, content: [article]).generateFeed()
        let rssDocument = try XMLDocument(xmlString: rss)
        let rssTitle = try #require(rssDocument.nodes(forXPath: "/rss/channel/item/title").first?.stringValue)
        #expect(rssTitle == expected)
        let rssSummary = try #require(rssDocument.nodes(forXPath: "/rss/channel/item/description").first?.stringValue)
        #expect(rssSummary == article.description)
        #expect(try SwiftSoup.parseBodyFragment(rssSummary).text() == expected)
        let rssContent = try rssDocument.nodes(forXPath: "/rss/channel/item/*[local-name()='encoded']").first?.stringValue

        let atom = AtomFeedGenerator(config: config, site: site, content: [article]).generateFeed()
        let atomDocument = try XMLDocument(xmlString: atom)
        let atomTitle = try #require(atomDocument.nodes(forXPath: "/*[local-name()='feed']/*[local-name()='entry']/*[local-name()='title']").first?.stringValue)
        #expect(atomTitle == expected)
        let atomSummary = try #require(atomDocument.nodes(forXPath: "/*[local-name()='feed']/*[local-name()='entry']/*[local-name()='summary']").first?.stringValue)
        #expect(atomSummary == article.description)
        #expect(try SwiftSoup.parseBodyFragment(atomSummary).text() == expected)
        let atomContent = try atomDocument.nodes(forXPath: "/*[local-name()='feed']/*[local-name()='entry']/*[local-name()='content']").first?.stringValue

        let json = JSONFeedGenerator(config: config, site: site, content: [article]).generateFeed()
        let data = try #require(json.data(using: .utf8))
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let item = try #require((object["items"] as? [[String: Any]])?.first)
        #expect(item["title"] as? String == expected)
        #expect(item["summary"] as? String == expected)

        if mode == .full {
            let rssBody = try #require(rssContent)
            let atomBody = try #require(atomContent)
            let jsonBody = try #require(item["content_html"] as? String)
            #expect(rssBody == article.text)
            #expect(atomBody == article.text)
            #expect(jsonBody == article.text)
            #expect(try SwiftSoup.parseBodyFragment(rssBody).text() == expected)
            #expect(try SwiftSoup.parseBodyFragment(atomBody).text() == expected)
            #expect(try SwiftSoup.parseBodyFragment(jsonBody).text() == expected)
            #expect(item["content_text"] == nil)
        } else {
            #expect(rssContent == nil)
            #expect(atomContent == nil)
            #expect(item["content_html"] == nil)
            #expect(item["content_text"] as? String == expected)
        }
    }

    @Test("Front-matter titles remain literal feed text", .publishingContext())
    func metadataTitleRemainsLiteral() throws {
        let article = try loadArticle("---\ntitle: Literal &lt;\n---\n# Ignored heading\n\nSummary")
        #expect(article.title == "Literal &lt;")
        try expectFeedMetadata(article, title: "Literal &lt;", summary: "Summary")
    }

    @Test("Filename fallback titles remain literal feed text", .publishingContext())
    func filenameTitleRemainsLiteral() throws {
        let article = try loadArticle("Summary", filename: "Literal &lt;.md")
        #expect(article.title == "Literal &lt;")
        try expectFeedMetadata(article, title: "Literal &lt;", summary: "Summary")
    }

    @Test("Public overrides remain literal and do not change the original article", .publishingContext(), arguments: [false, true])
    func publicOverridesRemainLiteral(assignSameValue: Bool) throws {
        let original = try loadArticle("# `&lt;`\n\n`&lt;`")
        var changed = original
        let replacement = assignSameValue ? original.title : "Replacement &lt;"
        changed.title = replacement
        changed.description = replacement

        try expectFeedMetadata(changed, title: replacement, summary: replacement)
        try expectFeedMetadata(original, title: "&lt;", summary: "&lt;")
    }

    @Test("Directly assigned article fields remain literal feed text", .publishingContext())
    func directAssignmentsRemainLiteral() throws {
        var article = Article()
        article.title = "Literal &lt;"
        article.description = "Summary &amp;"
        article.path = "/articles/example"
        try expectFeedMetadata(article, title: "Literal &lt;", summary: "Summary &amp;")
    }

    @Test("Ordinary Markdown entities are not decoded again in feeds", .publishingContext(), arguments: [
        ("Literal &amp;lt;", "Literal &lt;"),
        ("Literal &amp;lt; and `a & b`", "Literal &lt; and a & b")
    ])
    func ordinaryEntitiesRemainLiteral(markdown: String, expected: String) throws {
        let article = try loadArticle("# \(markdown)\n\n\(markdown)")
        try expectFeedMetadata(article, title: expected, summary: expected)
    }

    @Test("Feed text preserves formatting contents without interpreting code", .publishingContext(), arguments: [
        ("**Use `Array<String>`** and [link](https://example.com)", "Use Array<String> and link"),
        ("Raw <em>HTML</em> and `Array<String>`", "Raw HTML and Array<String>"),
        ("Code `a & b`![Logo](/logo.png)", "Code a & b"),
        ("**Bold** and ~~old~~ and [link](https://example.com)", "Bold and old and link")
    ])
    func formattingRetainsItsText(markdown: String, expected: String) throws {
        let article = try loadArticle("# \(markdown)\n\n\(markdown)")
        try expectFeedMetadata(article, title: expected, summary: expected)
    }

    private func expectFeedMetadata(_ article: Article, title: String, summary: String) throws {
        let site = TestSite()
        let config = try #require(FeedConfiguration(mode: .descriptionOnly, contentCount: 20))
        let rss = FeedGenerator(config: config, site: site, content: [article]).generateFeed()
        let rssDocument = try XMLDocument(xmlString: rss)
        #expect(try rssDocument.nodes(forXPath: "/rss/channel/item/title").first?.stringValue == title)

        let atom = AtomFeedGenerator(config: config, site: site, content: [article]).generateFeed()
        let atomDocument = try XMLDocument(xmlString: atom)
        #expect(try atomDocument.nodes(forXPath: "/*[local-name()='feed']/*[local-name()='entry']/*[local-name()='title']").first?.stringValue == title)

        let json = JSONFeedGenerator(config: config, site: site, content: [article]).generateFeed()
        let data = try #require(json.data(using: .utf8))
        let object = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let item = try #require((object["items"] as? [[String: Any]])?.first)
        #expect(item["title"] as? String == title)
        #expect(item["summary"] as? String == summary)
        #expect(item["content_text"] as? String == summary)
    }

    private func loadArticle(_ markdown: String, filename: String = "article.md") throws -> Article {
        let directory = FileManager.default.temporaryDirectory.appending(path: "ignite-markdown-feed-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let fileURL = directory.appending(path: filename)
        try markdown.write(to: fileURL, atomically: true, encoding: .utf8)
        let resourceValues = try fileURL.resourceValues(forKeys: Set(Article.resourceKeys))
        return try Article(from: fileURL, resourceValues: resourceValues, deployPath: "/articles/example")
    }
}
