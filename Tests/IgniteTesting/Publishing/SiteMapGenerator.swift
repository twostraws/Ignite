//
// SiteMapGenerator.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `SiteMapGenerator` output formatting.
@Suite("SiteMapGenerator Tests")
@MainActor
struct SiteMapGeneratorTests {
    /// Creates a fresh PublishingContext to avoid shared singleton state leaking between tests.
    private func freshContext() throws -> PublishingContext {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
        return PublishingContext.shared
    }

    @Test("Empty sitemap produces valid XML wrapper")
    func emptySitemap() throws {
        let context = try freshContext()
        let generator = SiteMapGenerator(context: context)
        let output = generator.generateSiteMap()

        #expect(output == """
        <?xml version="1.0" encoding="UTF-8"?>\
        <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\
        </urlset>
        """)
    }

    @Test("Single location produces correct XML entry")
    func singleLocation() throws {
        let context = try freshContext()
        context.addToSiteMap("/about", priority: 0.8)
        let generator = SiteMapGenerator(context: context)
        let output = generator.generateSiteMap()

        #expect(output.contains("<url><loc>https://www.example.com/about/</loc><priority>0.8</priority></url>"))
    }

    @Test("Multiple locations produce correct XML entries")
    func multipleLocations() throws {
        let context = try freshContext()
        context.addToSiteMap("/", priority: 1.0)
        context.addToSiteMap("/about", priority: 0.8)
        context.addToSiteMap("/blog", priority: 0.6)
        let generator = SiteMapGenerator(context: context)
        let output = generator.generateSiteMap()

        #expect(output.contains("<priority>1.0</priority>"))
        #expect(output.contains("<priority>0.8</priority>"))
        #expect(output.contains("<priority>0.6</priority>"))
        #expect(output.contains("<loc>https://www.example.com/</loc>"))
        #expect(output.contains("<loc>https://www.example.com/about/</loc>"))
        #expect(output.contains("<loc>https://www.example.com/blog/</loc>"))
    }

    @Test("Sitemap uses site URL for location prefix")
    func siteURLPrefix() throws {
        let context = try freshContext()
        context.addToSiteMap("/page", priority: 0.5)
        let generator = SiteMapGenerator(context: context)
        let output = generator.generateSiteMap()

        #expect(output.contains("<loc>https://www.example.com/page/</loc>"))
    }

    @Test("Sitemap preserves insertion order")
    func preservesOrder() throws {
        let context = try freshContext()
        context.addToSiteMap("/second", priority: 0.5)
        context.addToSiteMap("/first", priority: 0.9)
        let generator = SiteMapGenerator(context: context)
        let output = generator.generateSiteMap()

        let secondRange = try #require(output.range(of: "/second"))
        let firstRange = try #require(output.range(of: "/first"))

        #expect(secondRange.lowerBound < firstRange.lowerBound)
    }
}
