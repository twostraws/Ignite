//
//  Code.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Code` element.
@Suite("Code Tests")
@MainActor
class CodeTests: IgniteTestSuite {
    @Test("Inline code formatting")
    func inlineCode() async throws {
        let element = Code("background-color")
        let output = element.render()
        #expect(output == "<code>background-color</code>")
    }
}
