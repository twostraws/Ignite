//
//  Axis.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Axis` type.
@Suite("Axis Tests")
@MainActor
struct AxisTests {
    @Test("Individual axes have distinct raw values")
    func individualAxesHaveDistinctRawValues() async throws {
        #expect(Axis.horizontal.rawValue == 1)
        #expect(Axis.vertical.rawValue == 2)
        #expect(Axis.horizontal.rawValue != Axis.vertical.rawValue)
    }

    @Test("All contains both axes")
    func allContainsBothAxes() async throws {
        #expect(Axis.all.contains(.horizontal))
        #expect(Axis.all.contains(.vertical))
    }

    @Test("All equals union of horizontal and vertical")
    func allEqualsUnion() async throws {
        let combined: Axis = [.horizontal, .vertical]
        #expect(combined == Axis.all)
    }

    @Test("Individual axes do not contain each other")
    func individualAxesDoNotContainEachOther() async throws {
        #expect(!Axis.horizontal.contains(.vertical))
        #expect(!Axis.vertical.contains(.horizontal))
    }

    @Test("Empty axis set contains nothing")
    func emptyAxisSetContainsNothing() async throws {
        let empty = Axis()
        #expect(!empty.contains(.horizontal))
        #expect(!empty.contains(.vertical))
    }
}
