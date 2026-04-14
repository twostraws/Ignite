//
// AtomFeedGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `AtomFeedGenerator` type.
@Suite("AtomFeedGenerator Tests")
@MainActor
struct AtomFeedGeneratorTests {
    static let sites: [any Site] = [
        TestSite(),
        TestSite(timeZone: .init(abbreviation: "GMT")!),
        TestSite(timeZone: .init(abbreviation: "EST")!)
    ]

    // MARK: - Golden path

    @Test("Golden path: single article with all basic fields", arguments: await sites)
    func goldenPath(for site: any Site) async throws {
        let config = site.feedConfiguration!
        let atomPath = config.paths[.atom] ?? "/feed.atom"
        let selfHref = site.url.appending(path: atomPath).absoluteString

        var article = Article()
        article.title = "Example Title"
        article.description = "Example Description"

        let generator = AtomFeedGenerator(config: config, site: site, content: [article])

        #expect(generator.generateFeed() == """
        <?xml version="1.0" encoding="UTF-8"?>\
        <feed xmlns="http://www.w3.org/2005/Atom">\
        <title>\(site.name.xmlEscaped)</title>\
        <link href="\(site.url.absoluteString)" rel="alternate"/>\
        <link href="\(selfHref)" rel="self" type="application/atom+xml"/>\
        <id>\(site.url.absoluteString)/</id>\
        <updated>\(article.date.asRFC3339(timeZone: site.timeZone))</updated>\
        <generator uri="https://github.com/twostraws/Ignite" \
        version="\(Ignite.version)">Ignite</generator>\
        <icon>\(config.image?.url ?? "")</icon>\
        <logo>\(config.image?.url ?? "")</logo>\
        <entry>\
        <title>\(article.title.xmlEscaped)</title>\
        <link href="\(article.path(in: site))" rel="alternate"/>\
        <id>\(article.path(in: site))</id>\
        <updated>\(article.date.asRFC3339(timeZone: site.timeZone))</updated>\
        <published>\(article.date.asRFC3339(timeZone: site.timeZone))</published>\
        <summary type="html"><![CDATA[\(article.description)]]></summary>\
        </entry>\
        </feed>
        """)
    }

    // MARK: - Description-only mode

    @Test("Description-only mode has summary but no content element")
    func descriptionOnlyMode() async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 20)!
        let site = TestSite()

        var article = Article()
        article.title = "Test Article"
        article.description = "A short description"
        article.text = "<p>Full body HTML</p>"

        let generator = AtomFeedGenerator(config: config, site: site, content: [article])
        let feed = generator.generateFeed()

        #expect(feed.contains("<summary type=\"html\"><![CDATA[A short description]]></summary>"))
        #expect(!feed.contains("<content type=\"html\">"))
    }

    // MARK: - Full-content mode

    @Test("Full-content mode includes content element with absolute links")
    func fullContentMode() async throws {
        let config = FeedConfiguration(mode: .full, contentCount: 20)!
        let site = TestSite()

        var article = Article()
        article.title = "Test Article"
        article.description = "A short description"
        article.text = "<p>Full body HTML</p>"

        let generator = AtomFeedGenerator(config: config, site: site, content: [article])
        let feed = generator.generateFeed()

        let expectedContent = article.text.makingAbsoluteLinks(relativeTo: site.url)
        #expect(feed.contains("<content type=\"html\"><![CDATA[\(expectedContent)]]></content>"))
    }

    // MARK: - XML escaping in titles

    @Test("XML special characters in titles are escaped")
    func xmlEscapingInTitles() async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 20)!
        let site = TestSite()

        var article = Article()
        article.title = "Tom & Jerry <Adventures>"
        article.description = "A description"

        let generator = AtomFeedGenerator(config: config, site: site, content: [article])
        let feed = generator.generateFeed()

        #expect(feed.contains("<title>Tom &amp; Jerry &lt;Adventures&gt;</title>"))
    }

    // MARK: - Multiple articles

    @Test("Multiple articles preserve ordering")
    func multipleArticles() async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 20)!
        let site = TestSite()

        var first = Article()
        first.title = "First Article"
        first.description = "First"

        var second = Article()
        second.title = "Second Article"
        second.description = "Second"

        var third = Article()
        third.title = "Third Article"
        third.description = "Third"

        let generator = AtomFeedGenerator(
            config: config,
            site: site,
            content: [first, second, third]
        )
        let feed = generator.generateFeed()

        guard let firstRange = feed.range(of: "First Article"),
              let secondRange = feed.range(of: "Second Article"),
              let thirdRange = feed.range(of: "Third Article") else {
            Issue.record("Expected all three article titles in the feed")
            return
        }

        #expect(firstRange.lowerBound < secondRange.lowerBound)
        #expect(secondRange.lowerBound < thirdRange.lowerBound)
    }

    // MARK: - Empty optional fields

    @Test("Nil author and nil tags are handled gracefully")
    func emptyOptionalFields() async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 20)!

        // TestSite has author = "" so site-level author is empty
        let site = TestSite()

        var article = Article()
        article.title = "No Author Article"
        article.description = "Description"

        let generator = AtomFeedGenerator(config: config, site: site, content: [article])
        let feed = generator.generateFeed()

        // No author element at feed level (site.author is empty)
        #expect(!feed.contains("<author>"))
        // No category elements (article has no tags)
        #expect(!feed.contains("<category"))
    }

    // MARK: - Feed image

    @Test("Icon element present when image is configured")
    func feedImagePresent() async throws {
        let config = FeedConfiguration(
            mode: .descriptionOnly,
            contentCount: 20,
            image: .init(url: "https://example.com/icon.png", width: 100, height: 100)
        )!
        let site = TestSite()

        let generator = AtomFeedGenerator(config: config, site: site, content: [])
        let feed = generator.generateFeed()

        #expect(feed.contains("<icon>https://example.com/icon.png</icon>"))
        #expect(feed.contains("<logo>https://example.com/icon.png</logo>"))
    }

    @Test("Icon and logo elements absent when no image configured")
    func feedImageAbsent() async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 20)!
        let site = TestSite()

        let generator = AtomFeedGenerator(config: config, site: site, content: [])
        let feed = generator.generateFeed()

        #expect(!feed.contains("<icon>"))
        #expect(!feed.contains("<logo>"))
    }

    // MARK: - Timezone handling

    @Test("Timezone affects date formatting", arguments: await sites)
    func timezoneHandling(for site: any Site) async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 20)!

        var article = Article()
        article.title = "Timezone Test"
        article.description = "Testing timezones"

        let generator = AtomFeedGenerator(config: config, site: site, content: [article])
        let feed = generator.generateFeed()

        let expectedDate = article.date.asRFC3339(timeZone: site.timeZone)
        #expect(feed.contains("<updated>\(expectedDate)</updated>"))
        #expect(feed.contains("<published>\(expectedDate)</published>"))
    }

    // MARK: - Content count limiting

    @Test("Content count limits number of entries")
    func contentCountLimiting() async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 2)!
        let site = TestSite()

        var articles: [Article] = []
        for i in 1...5 {
            var article = Article()
            article.title = "Article \(i)"
            article.description = "Description \(i)"
            articles.append(article)
        }

        let generator = AtomFeedGenerator(config: config, site: site, content: articles)
        let feed = generator.generateFeed()

        #expect(feed.contains("Article 1"))
        #expect(feed.contains("Article 2"))
        #expect(!feed.contains("Article 3"))
    }
}
