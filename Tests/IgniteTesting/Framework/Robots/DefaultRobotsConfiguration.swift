//
// Untitled.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for `DefaultRobotsConfiguration`.
@Suite("DefaultRobotsConfiguration Tests")
@MainActor
struct DefaultRobotsConfigurationTests {
    @Test("Assert `disallowRules` is empty by default")
    func assertMockConformsToProtocol() async throws {
        let configuration = DefaultRobotsConfiguration()
        #expect(configuration.disallowRules.isEmpty)
    }

    @Test("Assert `disallowRules` reflects updates")
    mutating func assertDisallowRules() async throws {
        var configuration = DefaultRobotsConfiguration()
        configuration.disallowRules = [DisallowRule(name: "example")]
        #expect(!configuration.disallowRules.isEmpty)
    }
}
