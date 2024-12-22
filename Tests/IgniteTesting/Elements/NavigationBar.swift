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
@MainActor struct NavigationBarTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Default Column Width Test")
    func test_defaultColumnWidth() async throws {
        let element = NavigationBar().width(.viewport)
        let output = element.render(context: publishingContext)

        #expect(output.contains("container-fluid col"))
    }
    @Test("Column With Value Test")
    func test_columnWidthValueSet() async throws {
        let element = NavigationBar().width(.count(10))
        let output = element.render(context: publishingContext)

        #expect(output.contains("container col-md-10"))
    }
}
