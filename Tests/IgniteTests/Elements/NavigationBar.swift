//
// NavigationBar.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import XCTest
@testable import Ignite

/// Tests for the `NavigationBar` element.
final class NavigationBarTests: ElementTest {
    
    func test_defaultColumnWidth() {
        let element = NavigationBar()
        let output = element.render(context: publishingContext)
        
        XCTAssertTrue(output.contains("container-fluid col"))
    }
    
    func test_columnWidthValueSet() {
        let element = NavigationBar().width(10)
        let output = element.render(context: publishingContext)
        
        XCTAssertTrue(output.contains("container-fluid col-md-10"))
    }
}
