//
//  UnorderedListMarkerStyle.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `UnorderedListMarkerStyle` type.
@Suite("UnorderedListMarkerStyle Tests")
@MainActor
struct UnorderedListMarkerStyleTests {
    @Test("Raw values match CSS list-style-type values", arguments: zip(
        [UnorderedListMarkerStyle.automatic, .circle, .square, .custom],
        ["disc", "circle", "square", "custom"]))
    func rawValues(style: UnorderedListMarkerStyle, expected: String) async throws {
        #expect(style.rawValue == expected)
    }

    @Test("Automatic defaults to disc")
    func automaticDefaultsToDisc() async throws {
        #expect(UnorderedListMarkerStyle.automatic.rawValue == "disc")
    }
}
