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
struct NavigationBarTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Default Column Width Test")
    func test_defaultColumnWidth() async throws {
        let element = NavigationBar()
        let output = element.render(context: publishingContext)

        #expect(output.contains("container-fluid col"))
    }
    @Test("Column With Value Test")
    func test_columnWidthValueSet() async throws {
        let element = NavigationBar().width(10)
        let output = element.render(context: publishingContext)

        #expect(output.contains("container-fluid col-md-10"))
    }
}
