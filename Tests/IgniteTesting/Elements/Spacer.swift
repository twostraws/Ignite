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
struct SpacerTests {
    @Test("SpacerTest")
    func basicSpacerTest() async throws {
        let element = Spacer()
        let output = element.render()

        #expect(output == "<div class=\"justify-content-center align-items-center\" style=\"height: 20px\"></div>")
    }
}
