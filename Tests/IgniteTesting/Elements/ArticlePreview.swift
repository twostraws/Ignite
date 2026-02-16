//
//  ContentPreview.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

private struct CustomPreviewMarkup: HTML {
    var body: some HTML { self }
    var attributes = CoreAttributes()
    var isPrimitive: Bool { true }

    func markup() -> Markup {
        Markup("<section\(attributes)>Custom Preview Layout</section>")
    }
}

private struct CustomArticlePreviewStyle: ArticlePreviewStyle {
    nonisolated func body(content: Article) -> any HTML {
        CustomPreviewMarkup()
    }
}

/// Tests for the `ArticlePreview` element.
@Suite("ArticlePreview Tests")
@MainActor
class ArticlePreviewTests: IgniteTestSuite {
    @Test("Default layout renders card image title description and tag badges")
    func defaultLayoutRendersCardContent() async throws {
        var article = Article()
        article.title = "Testing Ignite"
        article.path = "/articles/testing-ignite/"
        article.description = "A guide to testing."
        article.metadata["tags"] = "Swift, Web Dev"
        article.metadata["image"] = "/images/testing.png"

        let output = ArticlePreview(for: article).markupString()

        #expect(output.contains(#"class="card""#))
        #expect(output.contains(#"src="/images/testing.png""#))
        #expect(output.contains(#"href="/articles/testing-ignite/""#))
        #expect(output.contains("Testing Ignite"))
        #expect(output.contains(#"class="mb-0 card-text""#))
        #expect(output.contains(#"href="/tags/swift""#))
        #expect(output.contains(#"href="/tags/web-dev""#))
        #expect(output.contains(#"rel="tag""#))
        #expect(output.contains(#"class="badge text-bg-primary rounded-pill""#))
        #expect(output.contains(#"style="margin-top: -5px""#))
    }

    @Test("Default layout omits footer when article has no tags")
    func defaultLayoutWithoutTagsOmitsFooter() async throws {
        var article = Article()
        article.title = "No Tags"
        article.path = "/articles/no-tags/"
        article.description = "No tags here."

        let output = ArticlePreview(for: article).markupString()

        #expect(!output.contains("card-footer"))
        #expect(!output.contains(#"rel="tag""#))
    }

    @Test("Custom style overrides default card layout and receives preview attributes")
    func customStyleOverridesDefaultLayout() async throws {
        var article = Article()
        article.description = "Body"

        let output = ArticlePreview(for: article)
            .articlePreviewStyle(CustomArticlePreviewStyle())
            .class("featured-preview")
            .markupString()

        #expect(output.contains(#"class="featured-preview""#))
        #expect(output.contains("Custom Preview Layout"))
        #expect(!output.contains(#"class="card""#))
    }
}
