//
//  OrderedListMarkerStyle.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `OrderedListMarkerStyle` type.
@Suite("OrderedListMarkerStyle Tests")
@MainActor
struct OrderedListMarkerStyleTests {
    @Test("Raw values match CSS list-style-type values", arguments: zip(
        [OrderedListMarkerStyle.automatic, .armenian, .cjkIdeographic,
         .decimalLeadingZero, .georgian, .hebrew,
         .hiragana, .hiraganaIroha, .katakana, .katakanaIroha,
         .lowerAlphabet, .lowerGreek, .lowerLatin, .lowerRoman,
         .upperAlphabet, .upperLatin, .upperRoman],
        ["decimal", "armenian", "cjk-ideographic",
         "decimal-leading-zero", "georgian", "hebrew",
         "hiragana", "hiragana-iroha", "katakana", "katakana-iroha",
         "lower-alpha", "lower-greek", "lower-latin", "lower-roman",
         "upper-alpha", "upper-latin", "upper-roman"]))
    func rawValues(style: OrderedListMarkerStyle, expected: String) async throws {
        #expect(style.rawValue == expected)
    }

    @Test("Automatic defaults to decimal")
    func automaticDefaultsToDecimal() async throws {
        #expect(OrderedListMarkerStyle.automatic.rawValue == "decimal")
    }
}
