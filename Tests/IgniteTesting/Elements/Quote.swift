//
//  Quote.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Quote` element.
@Suite("Quote Tests")
@MainActor
class QuoteTests: IgniteTestSuite {
    @Test("Plain Quote", arguments: ["It is a truth universally acknowledged..."])
    func plainQuoteTest(quoteText: String) async throws {
        let element = Quote {
            Text(quoteText)
        }

        let output = element.render()

        #expect(output == """
        <blockquote class="blockquote">\
        <p>\(quoteText)</p>\
        </blockquote>
        """)
    }

    @Test("Quote With Caption", arguments: ["Programming is an art."], ["Paul Hudson"])
    func quoteWithCaptionTest(quoteText: String, captionText: String) async throws {
        let element = Quote {
            Text(quoteText)
        } caption: {
            captionText
        }

        let output = element.render()

        #expect(output == """
        <blockquote class="blockquote">\
        <p>\(quoteText)</p>\
        <footer class="blockquote-footer">\(captionText)</footer>\
        </blockquote>
        """)
    }
}
