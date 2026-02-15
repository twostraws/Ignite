//
//  Edge.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Edge` type.
@Suite("Edge Tests")
@MainActor
struct EdgeTests {
    @Test("Individual edges have distinct raw values")
    func individualEdgesHaveDistinctRawValues() async throws {
        let edges: [Edge] = [.top, .leading, .bottom, .trailing]
        let rawValues = edges.map(\.rawValue)
        #expect(Set(rawValues).count == 4)
    }

    @Test("Individual edge raw values are powers of two")
    func individualEdgeRawValuesArePowersOfTwo() async throws {
        #expect(Edge.top.rawValue == 1)
        #expect(Edge.leading.rawValue == 2)
        #expect(Edge.bottom.rawValue == 4)
        #expect(Edge.trailing.rawValue == 8)
    }

    @Test("Horizontal contains leading and trailing")
    func horizontalContainsLeadingAndTrailing() async throws {
        #expect(Edge.horizontal.contains(.leading))
        #expect(Edge.horizontal.contains(.trailing))
        #expect(!Edge.horizontal.contains(.top))
        #expect(!Edge.horizontal.contains(.bottom))
    }

    @Test("Vertical contains top and bottom")
    func verticalContainsTopAndBottom() async throws {
        #expect(Edge.vertical.contains(.top))
        #expect(Edge.vertical.contains(.bottom))
        #expect(!Edge.vertical.contains(.leading))
        #expect(!Edge.vertical.contains(.trailing))
    }

    @Test("All contains every edge")
    func allContainsEveryEdge() async throws {
        #expect(Edge.all.contains(.top))
        #expect(Edge.all.contains(.leading))
        #expect(Edge.all.contains(.bottom))
        #expect(Edge.all.contains(.trailing))
    }

    @Test("All equals union of horizontal and vertical")
    func allEqualsUnionOfHorizontalAndVertical() async throws {
        let combined: Edge = [.horizontal, .vertical]
        #expect(combined == Edge.all)
    }

    @Test("OptionSet intersection works correctly")
    func optionSetIntersectionWorks() async throws {
        let result = Edge.all.intersection(.horizontal)
        #expect(result == Edge.horizontal)
    }

    @Test("OptionSet union works correctly")
    func optionSetUnionWorks() async throws {
        let result: Edge = [.top, .leading]
        #expect(result.contains(.top))
        #expect(result.contains(.leading))
        #expect(!result.contains(.bottom))
        #expect(!result.contains(.trailing))
    }

    @Test("Empty edge set contains nothing")
    func emptyEdgeSetContainsNothing() async throws {
        let empty = Edge()
        #expect(!empty.contains(.top))
        #expect(!empty.contains(.leading))
        #expect(!empty.contains(.bottom))
        #expect(!empty.contains(.trailing))
    }
}
