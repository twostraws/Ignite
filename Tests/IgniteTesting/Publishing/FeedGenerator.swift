//
// FeedGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FeedGenerator` type.
@Suite("FeedGenerator Tests")
@MainActor
struct FeedGeneratorTests {
    
    static let sites: [any Site] = [
        TestSite(),
        TestSite().withTimeZone(.init(abbreviation: "GMT")!),
        TestSite().withTimeZone(.init(abbreviation: "EST")!),
    ]
    
    @Test("Test generateFeed", arguments: await sites)
    func generateFeed(for site: any Site) async throws {
        let feedHref = site.url.appending(path: site.feedConfiguration.path).absoluteString
        var exampleContent = Content()
        exampleContent.title = "Example Title"
        exampleContent.description = "Example Description"

        let generator = FeedGenerator(site: site, content: [exampleContent])

        #expect(generator.generateFeed() == """
        <?xml version="1.0" encoding="UTF-8" ?>\
        <rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/" \
        xmlns:atom="http://www.w3.org/2005/Atom" \
        xmlns:content="http://purl.org/rss/1.0/modules/content/">\
        <channel>\
        <title>\(site.name)</title>\
        <description>\(site.description ?? "")</description>\
        <link>\(site.url.absoluteString)</link>\
        <atom:link
            href="\(feedHref)"
            rel="self" type="application/rss+xml"
        />\
        <language>\(site.language.rawValue)</language>\
        <generator>\(Ignite.version)</generator>\
        <image>\
        <url>\(site.feedConfiguration.image?.url ?? "")</url>\
        <title>\(site.name)</title>\
        <link>\(site.url.absoluteString)</link>\
        <width>\(site.feedConfiguration.image?.width ?? 0)</width>\
        <height>\(site.feedConfiguration.image?.height ?? 0)</height>\
        </image>\
        <item>\
        <guid isPermaLink="true">\(exampleContent.path(in: site))</guid>\
        <title>\(exampleContent.title)</title>\
        <link>\(exampleContent.path(in: site))</link>\
        <description><![CDATA[\(exampleContent.description)]]></description>\
        <pubDate>\(exampleContent.date.asRFC822(timeZone: site.timeZone))</pubDate>\
        </item>\
        </channel>\
        </rss>
        """)
    }
}
