//
//  ColumnWidth.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ColumnWidth` type.
@Suite("ColumnWidth Tests")
@MainActor
struct ColumnWidthTests {
    @Test("Uniform produces col class")
    func uniformProducesColClass() async throws {
        #expect(ColumnWidth.uniform.className == "col")
    }

    @Test("Intrinsic produces col-auto class")
    func intrinsicProducesColAutoClass() async throws {
        #expect(ColumnWidth.intrinsic.className == "col-auto")
    }

    @Test("Count produces col-md class", arguments: [1, 4, 6, 12])
    func countProducesColMdClass(width: Int) async throws {
        #expect(ColumnWidth.count(width).className == "col-md-\(width)")
    }

    @Test("Equatable conformance")
    func equatableConformance() async throws {
        #expect(ColumnWidth.uniform == ColumnWidth.uniform)
        #expect(ColumnWidth.intrinsic == ColumnWidth.intrinsic)
        #expect(ColumnWidth.count(6) == ColumnWidth.count(6))
        #expect(ColumnWidth.uniform != ColumnWidth.intrinsic)
        #expect(ColumnWidth.count(4) != ColumnWidth.count(8))
    }
}
