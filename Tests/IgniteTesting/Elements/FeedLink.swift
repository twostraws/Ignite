//
//  FeedLink.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FeedLink` component.
@Suite("FeedLink Tests")
@MainActor
class FeedLinkTests: IgniteTestSuite {
    /// Creates an environment with feed configuration from TestSite.
    private func environmentWithFeed() -> EnvironmentValues {
        EnvironmentValues(
            sourceDirectory: publishingContext.sourceDirectory,
            site: TestSite(),
            allContent: []
        )
    }

    @Test("Renders RSS Feed link when feed is configured")
    func rendersRSSFeedLink() async throws {
        let output = publishingContext.withEnvironment(environmentWithFeed()) {
            FeedLink().markupString()
        }
        #expect(output.contains("RSS Feed"))
        #expect(output.contains("/feed.rss"))
    }

    @Test("Renders as centered text")
    func renderedAsCenteredText() async throws {
        let output = publishingContext.withEnvironment(environmentWithFeed()) {
            FeedLink().markupString()
        }
        #expect(output.contains("text-center"))
    }

    @Test("Contains link element pointing to feed path")
    func containsLinkElement() async throws {
        let output = publishingContext.withEnvironment(environmentWithFeed()) {
            FeedLink().markupString()
        }
        #expect(output.contains("<a"))
        #expect(output.contains("href=\"/feed.rss\""))
    }

    @Test("Includes RSS icon when built-in icons are enabled")
    func includesRSSIcon() async throws {
        let output = publishingContext.withEnvironment(environmentWithFeed()) {
            FeedLink().markupString()
        }
        #expect(output.contains("rss-fill"))
    }

    @Test("Renders empty when no feed is configured")
    func rendersEmptyWithoutFeedConfig() async throws {
        let element = FeedLink()
        let output = element.markupString()
        #expect(output == "")
    }
}
