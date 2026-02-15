//
//  FillMode.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `FillMode` type.
@Suite("FillMode Tests")
@MainActor
struct FillModeTests {
    @Test("Raw values match CSS animation-fill-mode values", arguments: zip(
        [FillMode.none, .forwards, .backwards, .both],
        ["none", "forwards", "backwards", "both"]))
    func rawValues(mode: FillMode, expected: String) async throws {
        #expect(mode.rawValue == expected)
    }

    @Test("Hashable conformance")
    func hashableConformance() async throws {
        let set: Set<FillMode> = [.none, .forwards, .backwards, .both, .none]
        #expect(set.count == 4)
    }
}
