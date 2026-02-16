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
}
