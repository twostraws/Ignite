//
//  Abbreviation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//  Created by Henrik Christensen 2024-05-03.
//

import Foundation

import XCTest
@testable import Ignite

/// Tests for the `Abbreviation` element.
final class AbbreviationTests: ElementTest {
    func test_singleElement() {
        let element = Abbreviation("abbr", description: "abbreviation")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, "<abbr title=\"abbreviation\">abbr</abbr>")
    }
}
