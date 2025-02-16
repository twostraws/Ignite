//
//  Underline.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Underline` element.
@Suite("Underline Tests")
@MainActor
class UnderlineTests: IgniteTestSuite {
    @Test("Single Element Test", arguments: ["This is a test", "Another test", ""])
    func singleElement(underlineText: String) async throws {
        let element = Underline(underlineText)
        let output = element.render()

        #expect(output == "<u>\(underlineText)</u>")
    }

    @Test("Builder", arguments: ["This is a test", "Another test", ""])
    func builder(underlineText: String) async throws {
        let element = Underline { underlineText }
        let output = element.render()

        #expect(output == "<u>\(underlineText)</u>")
    }
}
