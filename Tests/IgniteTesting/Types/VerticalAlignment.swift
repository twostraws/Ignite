//
//  VerticalAlignment.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `VerticalAlignment` type.
@Suite("VerticalAlignment Tests")
@MainActor
struct VerticalAlignmentTests {
    @Test("Container alignment classes", arguments: zip(
        [VerticalAlignment.top, .center, .bottom],
        ["align-items-start", "align-items-center", "align-items-end"]))
    func containerAlignmentClasses(
        alignment: VerticalAlignment,
        expectedClass: String
    ) async throws {
        #expect(alignment.containerAlignmentClass == expectedClass)
    }

    @Test("Item alignment classes", arguments: zip(
        [VerticalAlignment.top, .center, .bottom],
        ["align-self-start", "align-self-center", "align-self-end"]))
    func itemAlignmentClasses(
        alignment: VerticalAlignment,
        expectedClass: String
    ) async throws {
        #expect(alignment.itemAlignmentClass == expectedClass)
    }

    @Test("All cases are equatable")
    func allCasesAreEquatable() async throws {
        #expect(VerticalAlignment.top == VerticalAlignment.top)
        #expect(VerticalAlignment.center == VerticalAlignment.center)
        #expect(VerticalAlignment.bottom == VerticalAlignment.bottom)
        #expect(VerticalAlignment.top != VerticalAlignment.bottom)
        #expect(VerticalAlignment.top != VerticalAlignment.center)
        #expect(VerticalAlignment.center != VerticalAlignment.bottom)
    }
}
