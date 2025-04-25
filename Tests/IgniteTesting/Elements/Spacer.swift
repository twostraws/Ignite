//
//  Spacer.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Spacer` element.
@Suite("Spacer Tests")
@MainActor
class SpacerTests: IgniteTestSuite {
    @Test("SpacerTest")
    func basicSpacerTest() async throws {
        let element = Spacer()
        let output = element.markupString()

        #expect(output == "<div class=\"mt-auto\"></div>")
    }
}
