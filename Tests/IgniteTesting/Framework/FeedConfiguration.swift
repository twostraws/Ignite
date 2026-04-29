//
//  FeedConfiguration.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `FeedConfiguration` type.
@Suite("FeedConfiguration Tests")
@MainActor
struct FeedConfigurationTests {
    // MARK: - Failable initializer

    @Test("Returns nil for zero content count")
    func nilForZeroContentCount() async throws {
        let config = FeedConfiguration(mode: .full, contentCount: 0)
        #expect(config == nil)
    }

    @Test("Returns nil for negative content count")
    func nilForNegativeContentCount() async throws {
        let config = FeedConfiguration(mode: .full, contentCount: -5)
        #expect(config == nil)
    }

    @Test("Returns non-nil for positive content count")
    func nonNilForPositiveContentCount() async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 10)
        #expect(config != nil)
        #expect(config?.contentCount == 10)
        #expect(config?.mode == .descriptionOnly)
    }

    // MARK: - Path defaults

    @Test("Default path is /feed.rss")
    func defaultPath() async throws {
        let config = FeedConfiguration(mode: .full, contentCount: 5)
        #expect(config?.path == "/feed.rss")
    }

    @Test("Custom path is preserved")
    func customPath() async throws {
        let config = FeedConfiguration(mode: .full, contentCount: 5, path: "/custom/rss.xml")
        #expect(config?.path == "/custom/rss.xml")
    }

    // MARK: - FeedImage

    @Test("FeedImage stores valid dimensions")
    func feedImageStoresProperties() async throws {
        let image = FeedConfiguration.FeedImage(url: "/icon.png", width: 100, height: 200)
        #expect(image.url == "/icon.png")
        #expect(image.width == 100)
        #expect(image.height == 200)
    }

    // MARK: - FeedFormat

    @Test("FeedFormat has all expected cases")
    func feedFormatCases() async throws {
        let allCases = FeedFormat.allCases
        #expect(allCases.count == 3)
        #expect(allCases.contains(.rss))
        #expect(allCases.contains(.atom))
        #expect(allCases.contains(.json))
    }

    @Test("FeedFormat raw values are correct")
    func feedFormatRawValues() async throws {
        #expect(FeedFormat.rss.rawValue == "rss")
        #expect(FeedFormat.atom.rawValue == "atom")
        #expect(FeedFormat.json.rawValue == "json")
    }

    // MARK: - Multi-format configuration

    @Test("Default formats is RSS only")
    func defaultFormatsIsRSSOnly() async throws {
        let config = FeedConfiguration(mode: .descriptionOnly, contentCount: 10)
        #expect(config?.formats == [.rss])
    }

    @Test("Multiple formats can be specified")
    func multipleFormats() async throws {
        let config = FeedConfiguration(
            mode: .full,
            contentCount: 10,
            formats: [.rss, .atom, .json]
        )
        #expect(config?.formats == [.rss, .atom, .json])
    }

    // MARK: - Per-format paths

    @Test("Default paths are assigned for each format")
    func defaultPathsPerFormat() async throws {
        let config = FeedConfiguration(
            mode: .full,
            contentCount: 10,
            formats: [.rss, .atom, .json]
        )
        #expect(config?.paths[.rss] == "/feed.rss")
        #expect(config?.paths[.atom] == "/feed.atom")
        #expect(config?.paths[.json] == "/feed.json")
    }

    @Test("Custom path parameter sets RSS path")
    func customPathSetsRSSPath() async throws {
        let config = FeedConfiguration(
            mode: .full,
            contentCount: 10,
            path: "/custom/rss.xml",
            formats: [.rss, .atom]
        )
        #expect(config?.paths[.rss] == "/custom/rss.xml")
        #expect(config?.paths[.atom] == "/feed.atom")
    }

    @Test("Per-format paths override defaults")
    func perFormatPathsOverrideDefaults() async throws {
        let config = FeedConfiguration(
            mode: .full,
            contentCount: 10,
            formats: [.rss, .atom, .json],
            paths: [.atom: "/my-atom.xml", .json: "/api/feed.json"]
        )
        #expect(config?.paths[.atom] == "/my-atom.xml")
        #expect(config?.paths[.json] == "/api/feed.json")
        #expect(config?.paths[.rss] == "/feed.rss")
    }

    @Test("Backward-compatible path property maps to RSS")
    func backwardCompatiblePathProperty() async throws {
        let config = FeedConfiguration(mode: .full, contentCount: 10, path: "/legacy.rss")
        #expect(config?.path == "/legacy.rss")
    }
}
