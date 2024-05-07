//
//  Abbreviation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests for the `Abbreviation` element.
final class AbbreviationTests: ElementTest {
    func test_basic() {
        let element = Abbreviation("abbr", description: "abbreviation")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<abbr title=\"abbreviation\">abbr</abbr>")
    }
    
    func test_singleElement() {
        let element = Abbreviation(Strong("abbr"), description: "abbreviation")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<abbr title=\"abbreviation\"><strong>abbr</strong></abbr>")
    }

    func test_builder() {
        let element = Abbreviation("abbreviation") {
            Strong {
                "abbr"
            }
        }

        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<abbr title=\"abbreviation\"><strong>abbr</strong></abbr>")
    }
}
