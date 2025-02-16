//
//  Emphasis.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Emphasis` element.
@Suite("Emphasis Tests")
@MainActor
class EmphasisTests: IgniteTestSuite {
    @Test("Emphasis")
    func simpleEmphasis() async throws {
        let element = Emphasis("Although Markdown is still easier, to be honest! ")
        let output = element.render()

        #expect(output == "<em>Although Markdown is still easier, to be honest! </em>")
    }
}
