//
//  ForEach.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ForEach` element.
@Suite("ForEach Tests")
@MainActor
class ForEachTests: IgniteTestSuite {
    @Test("Renders items from an array of strings")
    func rendersItemsFromStringArray() async throws {
        let items = ["Hello", "World"]
        let element = ForEach(items) { item in
            Text(item)
        }

        let output = element.markupString()
        #expect(output == "<p>Hello</p><p>World</p>")
    }

    @Test("Renders nothing for empty array")
    func rendersNothingForEmptyArray() async throws {
        let items: [String] = []
        let element = ForEach(items) { item in
            Text(item)
        }

        let output = element.markupString()
        #expect(output == "")
    }

    @Test("Renders single item")
    func rendersSingleItem() async throws {
        let items = ["Only"]
        let element = ForEach(items) { item in
            Text(item)
        }

        let output = element.markupString()
        #expect(output == "<p>Only</p>")
    }

    @Test("Renders items from integer range")
    func rendersItemsFromIntegerRange() async throws {
        let element = ForEach(1...3) { number in
            Text("\(number)")
        }

        let output = element.markupString()
        #expect(output == "<p>1</p><p>2</p><p>3</p>")
    }

    @Test("Preserves order of items")
    func preservesOrderOfItems() async throws {
        let items = ["A", "B", "C", "D"]
        let element = ForEach(items) { item in
            Text(item)
        }

        let output = element.markupString()
        #expect(output == "<p>A</p><p>B</p><p>C</p><p>D</p>")
    }

    @Test("Works with complex elements")
    func worksWithComplexElements() async throws {
        let items = ["Link1", "Link2"]
        let element = ForEach(items) { item in
            Link(item, target: "/\(item.lowercased())")
        }

        let output = element.markupString()
        #expect(output.contains("Link1"))
        #expect(output.contains("Link2"))
        #expect(output.contains("/link1"))
        #expect(output.contains("/link2"))
    }
}
