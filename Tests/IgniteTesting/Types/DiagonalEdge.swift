//
//  DiagonalEdge.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `DiagonalEdge` type.
@Suite("DiagonalEdge Tests")
@MainActor
struct DiagonalEdgeTests {
    @Test("Individual edges have distinct raw values")
    func individualEdgesHaveDistinctRawValues() async throws {
        let edges: [DiagonalEdge] = [.topLeading, .topTrailing, .bottomLeading, .bottomTrailing]
        let rawValues = edges.map(\.rawValue)
        #expect(Set(rawValues).count == 4)
    }

    @Test("Individual edge raw values are powers of two")
    func individualEdgeRawValuesArePowersOfTwo() async throws {
        #expect(DiagonalEdge.topLeading.rawValue == 1)
        #expect(DiagonalEdge.topTrailing.rawValue == 2)
        #expect(DiagonalEdge.bottomLeading.rawValue == 4)
        #expect(DiagonalEdge.bottomTrailing.rawValue == 8)
    }

    @Test("Top contains topLeading and topTrailing")
    func topContainsBothTopCorners() async throws {
        #expect(DiagonalEdge.top.contains(.topLeading))
        #expect(DiagonalEdge.top.contains(.topTrailing))
        #expect(!DiagonalEdge.top.contains(.bottomLeading))
        #expect(!DiagonalEdge.top.contains(.bottomTrailing))
    }

    @Test("Bottom contains bottomLeading and bottomTrailing")
    func bottomContainsBothBottomCorners() async throws {
        #expect(DiagonalEdge.bottom.contains(.bottomLeading))
        #expect(DiagonalEdge.bottom.contains(.bottomTrailing))
        #expect(!DiagonalEdge.bottom.contains(.topLeading))
        #expect(!DiagonalEdge.bottom.contains(.topTrailing))
    }

    @Test("Leading contains topLeading and bottomLeading")
    func leadingContainsBothLeadingCorners() async throws {
        #expect(DiagonalEdge.leading.contains(.topLeading))
        #expect(DiagonalEdge.leading.contains(.bottomLeading))
        #expect(!DiagonalEdge.leading.contains(.topTrailing))
        #expect(!DiagonalEdge.leading.contains(.bottomTrailing))
    }

    @Test("Trailing contains topTrailing and bottomTrailing")
    func trailingContainsBothTrailingCorners() async throws {
        #expect(DiagonalEdge.trailing.contains(.topTrailing))
        #expect(DiagonalEdge.trailing.contains(.bottomTrailing))
        #expect(!DiagonalEdge.trailing.contains(.topLeading))
        #expect(!DiagonalEdge.trailing.contains(.bottomLeading))
    }

    @Test("All contains every diagonal edge")
    func allContainsEveryDiagonalEdge() async throws {
        #expect(DiagonalEdge.all.contains(.topLeading))
        #expect(DiagonalEdge.all.contains(.topTrailing))
        #expect(DiagonalEdge.all.contains(.bottomLeading))
        #expect(DiagonalEdge.all.contains(.bottomTrailing))
    }

    @Test("All equals union of leading and trailing")
    func allEqualsUnionOfLeadingAndTrailing() async throws {
        let combined: DiagonalEdge = [.leading, .trailing]
        #expect(combined == DiagonalEdge.all)
    }

    @Test("All equals union of top and bottom")
    func allEqualsUnionOfTopAndBottom() async throws {
        let combined: DiagonalEdge = [.top, .bottom]
        #expect(combined == DiagonalEdge.all)
    }

    @Test("Intersection of top and leading is topLeading")
    func intersectionOfTopAndLeadingIsTopLeading() async throws {
        let result = DiagonalEdge.top.intersection(.leading)
        #expect(result == .topLeading)
    }

    @Test("Intersection of bottom and trailing is bottomTrailing")
    func intersectionOfBottomAndTrailingIsBottomTrailing() async throws {
        let result = DiagonalEdge.bottom.intersection(.trailing)
        #expect(result == .bottomTrailing)
    }

    @Test("Empty diagonal edge set contains nothing")
    func emptyDiagonalEdgeSetContainsNothing() async throws {
        let empty = DiagonalEdge()
        #expect(!empty.contains(.topLeading))
        #expect(!empty.contains(.topTrailing))
        #expect(!empty.contains(.bottomLeading))
        #expect(!empty.contains(.bottomTrailing))
    }
}
