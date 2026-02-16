//
//  LazyLoadable.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `LazyLoadable` modifier.
@Suite("LazyLoadable Tests")
@MainActor
class LazyLoadableTests: IgniteTestSuite {
    @Test("Embed with lazy() adds loading=lazy attribute")
    func lazyEmbedAddsAttribute() async throws {
        let element = Embed(youTubeID: "abc123", title: "Test Video")
            .lazy()

        let output = element.markupString()

        #expect(output.contains(#"loading="lazy""#))
    }

    @Test("Embed without lazy() does not have loading attribute")
    func noLazyNoAttribute() async throws {
        let element = Embed(youTubeID: "abc123", title: "Test Video")

        let output = element.markupString()

        #expect(!output.contains("loading="))
    }
}
