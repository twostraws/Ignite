//
// ArticleMetadata.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing
@testable import Ignite

@Suite("Article Metadata Tests")
struct ArticleMetadataTests {
    @Test("Front matter ends at a delimiter line, not within a title", .publishingContext(), arguments:
        ["MyApp release notes", "MyApp --- release notes"],
        ["\n", "\r\n"]
    )
    func titleContainingDashes(title: String, newline: String) throws {
        let markdown = [
            "---",
            "title: \(title)",
            "date: 2024-08-31 12:34",
            "path: /news/release-notes",
            "author: Taylor Smith",
            "---",
            "The release is available."
        ].joined(separator: newline)

        let article = try loadArticle(markdown)
        let expectedDate = try #require(DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: .gmt,
            year: 2024,
            month: 8,
            day: 31,
            hour: 12,
            minute: 34
        ).date)

        #expect(article.title == title)
        #expect(article.date == expectedDate)
        #expect(!article.hasAutomaticDate)
        #expect(article.path == "/news/release-notes")
        #expect(article.author == "Taylor Smith")
        #expect(article.text == "<p>The release is available.</p>")
    }

    @Test("Thematic breaks remain in the body after front matter", .publishingContext(), arguments: ["\n", "\r\n"])
    func thematicBreakAfterMetadata(newline: String) throws {
        let markdown = [
            "---",
            "title: Release notes",
            "author: Taylor Smith",
            "---",
            "First paragraph.",
            "",
            "---",
            "",
            "Last paragraph."
        ].joined(separator: newline)

        let article = try loadArticle(markdown)

        #expect(article.title == "Release notes")
        #expect(article.author == "Taylor Smith")
        #expect(article.text == "<p>First paragraph.</p><hr /><p>Last paragraph.</p>")
    }

    @Test("Ordinary Markdown without front matter retains its title and body", .publishingContext(), arguments: ["\n", "\r\n"])
    func markdownWithoutMetadata(newline: String) throws {
        let markdown = [
            "# MyApp release notes",
            "",
            "First paragraph.",
            "",
            "---",
            "",
            "Last paragraph."
        ].joined(separator: newline)

        let article = try loadArticle(markdown)

        #expect(article.title == "MyApp release notes")
        #expect(article.path == "/articles/fallback")
        #expect(article.author == nil)
        #expect(article.hasAutomaticDate)
        #expect(article.text == "<p>First paragraph.</p><hr /><p>Last paragraph.</p>")
    }

    private func loadArticle(_ markdown: String) throws -> Article {
        let fileURL = FileManager.default.temporaryDirectory
            .appending(path: "ignite-article-metadata-\(UUID().uuidString).md")
        try markdown.write(to: fileURL, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: fileURL) }

        let resourceValues = try fileURL.resourceValues(forKeys: Set(Article.resourceKeys))
        return try Article(from: fileURL, resourceValues: resourceValues, deployPath: "/articles/fallback")
    }
}
