//
//  Abbreviation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation

import Testing
@testable import Ignite

/// Tests for the `Abbreviation` element.
@Suite("Abbreviation Tests")
struct AbbreviationTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Basic Abbreviation Test")
    func test_basic() async throws {
        let element = Abbreviation("abbr", description: "abbreviation")
        let output = element.render(context: publishingContext)

        #expect(output == "<abbr title=\"abbreviation\">abbr</abbr>")
    }
    @Test("Single Element Abbreviation Test")
    func test_singleElement() async throws {
        let element = Abbreviation(Strong("abbr"), description: "abbreviation")
        let output = element.render(context: publishingContext)

        #expect(output == "<abbr title=\"abbreviation\"><strong>abbr</strong></abbr>")
    }
    @Test("Builder Abbreviation Test")
    func test_builder() async throws {
        let element = Abbreviation("abbreviation") {
            Strong {
                "abbr"
            }
        }

        let output = element.render(context: publishingContext)

        #expect(output == "<abbr title=\"abbreviation\"><strong>abbr</strong></abbr>")
    }
}
