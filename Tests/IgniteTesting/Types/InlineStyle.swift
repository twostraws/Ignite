//
//  InlineStyle.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `InlineStyle` type.
@Suite("InlineStyle Tests")
@MainActor
struct InlineStyleTests {
    @Test("Description for property string initializer")
    func descriptionPropertyStringInit() async throws {
        let example = InlineStyle("font-size", value: "25px")
        #expect(example.description == "font-size: 25px")
    }

    @Test("Description for property initializer")
    func descriptionPropertyInit() async throws {
        let example = InlineStyle(Property.fontSize, value: "25px")
        #expect(example.description == "font-size: 25px")
    }

    static let stylePairs: [(lhs: InlineStyle, rhs: InlineStyle)] = [
        (.init(.absolutePosition, value: "top"), .init(.accentColor, value: "red")),
        (.init(.backgroundColor, value: "red"), .init(.absolutePosition, value: "top")),
        (.init(.textAlign, value: "center"), .init(.color, value: "red")),
        (.init(.justifyContent, value: "space-between"), .init(.alignItems, value: "end"))
    ]

    static let comparisonResults: [Bool] = [
        true,   // absolutePosition < accentColor
        false,  // backgroundColor > absolutePosition
        false,  // textAlign > color
        false   // justifyContent > alignItems
    ]

    @Test("Comparable operator", arguments: await zip(stylePairs, comparisonResults))
    func comparable(_ pair: (lhs: InlineStyle, rhs: InlineStyle), lessThan: Bool) async throws {
        #expect((pair.lhs < pair.rhs) == lessThan)
        #expect((pair.lhs > pair.rhs) == !lessThan)
    }
}
