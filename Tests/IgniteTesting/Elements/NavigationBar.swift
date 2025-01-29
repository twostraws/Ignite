//
// NavigationBar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `NavigationBar` element.
@Suite("Navigation Bar Tests")
@MainActor
class NavigationBarTests: IgniteSuite {
    @Test("Default Column Width Test")
    func defaultColumnWidth() async throws {
        let element = NavigationBar().width(.viewport)
        let output = element.render()

        #expect(output.contains("col container-fluid"))
    }

    @Test("Column With Value Test", arguments: [3, 6, 12])
    func columnWidthValueSet(count: Int) async throws {
        let element = NavigationBar().width(.count(count))
        let output = element.render()

        #expect(output.contains("col-md-\(count) container"))
    }
}
