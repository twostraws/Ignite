//
//  InlineForEach.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `InlineForEach` element.
@Suite("InlineForEach Tests")
@MainActor
class InlineForEachTests: IgniteTestSuite {
    @Test("Renders inline items from an array of strings")
    func rendersInlineItemsFromStringArray() async throws {
        let items = ["Hello", "World"]
        let element = InlineForEach(items) { item in
            Span(item)
        }

        let output = element.markupString()
        #expect(output == "<span>Hello</span><span>World</span>")
    }

    @Test("Renders nothing for empty array")
    func rendersNothingForEmptyArray() async throws {
        let items: [String] = []
        let element = InlineForEach(items) { item in
            Span(item)
        }

        let output = element.markupString()
        #expect(output == "")
    }

    @Test("Renders single inline item")
    func rendersSingleInlineItem() async throws {
        let items = ["Only"]
        let element = InlineForEach(items) { item in
            Span(item)
        }

        let output = element.markupString()
        #expect(output == "<span>Only</span>")
    }

    @Test("Preserves order of inline items")
    func preservesOrderOfInlineItems() async throws {
        let items = ["A", "B", "C"]
        let element = InlineForEach(items) { item in
            Span(item)
        }

        let output = element.markupString()
        #expect(output == "<span>A</span><span>B</span><span>C</span>")
    }

    @Test("Works with integer range")
    func worksWithIntegerRange() async throws {
        let element = InlineForEach(1...3) { number in
            Span("\(number)")
        }

        let output = element.markupString()
        #expect(output == "<span>1</span><span>2</span><span>3</span>")
    }
}
