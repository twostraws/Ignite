//
//  RobotsConfiguration.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for `RobotsConfiguration`.
@Suite("RobotsConfiguration Tests")
@MainActor
struct RobotsConfigurationTests {
    @Test("Assert that mock conforms to protocol")
    func assertMockConformsToProtocol() async throws {
        let mock: Any = RobotsConfigurationMock()
        #expect(mock is RobotsConfiguration)
    }
}

// MARK: - RobotsConfigurationMock

final class RobotsConfigurationMock: RobotsConfiguration {
    var disallowRules: [DisallowRule] = []
}
