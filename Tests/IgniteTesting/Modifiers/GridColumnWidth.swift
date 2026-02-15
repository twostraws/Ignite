//
//  GridColumnWidth.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `GridColumnWidthModifier`.
@Suite("GridColumnWidth Tests")
@MainActor
class GridColumnWidthTests: IgniteTestSuite {
    @Test("Width modifier applies col-md class", arguments: [1, 4, 6, 12])
    func widthModifierAppliesColMdClass(width: Int) async throws {
        let element = Text("Hello").width(width)
        let output = element.markupString()
        #expect(output.contains("col-md-\(width)"))
    }

    @Test("Width modifier wraps non-primitive content in section")
    func widthModifierOnSection() async throws {
        let element = Section {
            Text("Hello")
        }.width(6)
        let output = element.markupString()
        #expect(output.contains("col-md-6"))
    }
}
