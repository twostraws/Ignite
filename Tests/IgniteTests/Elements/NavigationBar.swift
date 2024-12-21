//
// NavigationBar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import XCTest
@testable import Ignite

/// Tests for the `NavigationBar` element.
@MainActor final class NavigationBarTests: ElementTest {

    func test_defaultColumnWidth() {
        let element = NavigationBar().width(.viewport)
        let output = element.render(context: publishingContext)
        print(output)
        XCTAssertTrue(output.contains("container-fluid col"))
}

    func test_columnWidthValueSet() {
        let element = NavigationBar().width(.count(10))
        let output = element.render(context: publishingContext)
        print(output)
        XCTAssertTrue(output.contains("container col-md-10"))

    }
}
