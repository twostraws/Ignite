//
//  Abbreviation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

@testable import Ignite
import XCTest

/// Tests for the `Abbreviation` element.
@MainActor final class AbbreviationTests: ElementTest {
    func test_basic() {
        let element = Abbreviation("abbr", description: "abbreviation")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<abbr title=\"abbreviation\">abbr</abbr>")
    }
    
    func test_singleElement() {
        let element = Abbreviation("abbreviation") { Strong("abbr") }
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<abbr title=\"abbreviation\"><strong>abbr</strong></abbr>")
    }

    func test_builder() {
        let element = Abbreviation("abbreviation") {
            Strong { "abbr" }
        }

        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<abbr title=\"abbreviation\"><strong>abbr</strong></abbr>")
    }
}
