//
//  KeyframeProxy.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for `KeyframeProxy`.
@Suite("KeyframeProxy Tests")
struct KeyframeProxyTests {
    @Test("callAsFunction creates keyframe with correct position", .publishingContext())
    func callAsFunctionPosition() async throws {
        let proxy = KeyframeProxy()
        let frame = proxy(50%)
        #expect(frame.position == 50%)
    }

    @Test("callAsFunction creates keyframe with empty styles", .publishingContext())
    func callAsFunctionEmptyStyles() async throws {
        let proxy = KeyframeProxy()
        let frame = proxy(0%)
        #expect(frame.styles.isEmpty)
    }
}
