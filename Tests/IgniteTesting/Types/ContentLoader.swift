//
//  ContentLoader.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `ContentLoader` type.
@Suite("ContentLoader Tests")
@MainActor
struct ContentLoaderTests {
    /// Creates a test article with the given type and tags metadata.
    private func makeArticle(title: String, type: String, tags: String? = nil) -> Article {
        var article = Article()
        article.title = title
        article.metadata["type"] = type
        if let tags {
            article.metadata["tags"] = tags
        }
        return article
    }

    @Test("ArticleLoader stores articles in all property")
    func storesArticles() async throws {
        let articles = [makeArticle(title: "A", type: "blog"), makeArticle(title: "B", type: "blog")]
        let loader = ArticleLoader(content: articles)

        #expect(loader.all.count == 2)
        #expect(loader.all[0].title == "A")
        #expect(loader.all[1].title == "B")
    }

    @Test("typed() filters articles by metadata type")
    func typedFilter() async throws {
        let articles = [
            makeArticle(title: "Blog Post", type: "blog"),
            makeArticle(title: "Story", type: "stories"),
            makeArticle(title: "Another Blog", type: "blog")
        ]
        let loader = ArticleLoader(content: articles)

        let blogs = loader.typed("blog")
        #expect(blogs.count == 2)
        #expect(blogs.allSatisfy { $0.type == "blog" })

        let stories = loader.typed("stories")
        #expect(stories.count == 1)
        #expect(stories[0].title == "Story")
    }

    @Test("typed() returns empty array when no matches")
    func typedNoMatches() async throws {
        let articles = [makeArticle(title: "A", type: "blog")]
        let loader = ArticleLoader(content: articles)

        #expect(loader.typed("news").isEmpty)
    }

    @Test("tagged() filters articles by parsed tags")
    func taggedFilter() async throws {
        let articles = [
            makeArticle(title: "Swift Post", type: "blog", tags: "swift, ios"),
            makeArticle(title: "Web Post", type: "blog", tags: "html, css"),
            makeArticle(title: "Mixed", type: "blog", tags: "swift, web")
        ]
        let loader = ArticleLoader(content: articles)

        let swiftArticles = loader.tagged("swift")
        #expect(swiftArticles.count == 2)

        let cssArticles = loader.tagged("css")
        #expect(cssArticles.count == 1)
        #expect(cssArticles[0].title == "Web Post")
    }

    @Test("tagged() returns empty array when no matches")
    func taggedNoMatches() async throws {
        let articles = [makeArticle(title: "A", type: "blog", tags: "swift")]
        let loader = ArticleLoader(content: articles)

        #expect(loader.tagged("python").isEmpty)
    }
}
