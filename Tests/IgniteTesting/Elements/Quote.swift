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
struct QuoteTests {
    @Test("Plain Quote Test", arguments: [
         """
         It is a truth universally acknowledged \
         that all good Swift projects must be in need of result builders.
         """
    ])
    func plainQuoteTest(quoteText: String) async throws {
        let element = Quote {
            Text(quoteText)
        }
        let output = element.render()

        #expect(output ==
            """
            <blockquote class="blockquote">\
            <p>\(quoteText)</p>\
            </blockquote>
            """
        )
    }
    @Test("Quote With Caption Test",
        arguments:
            [
                """
                "Programming is an art. Don't spend all your time sharpening your \
                pencil when you should be drawing.
                """
            ],
            ["Paul Hudson"]
    )
    func quoteWithCaptionTest(quoteText: String, captionText: String) async throws {
        let element = Quote {
            Text(quoteText)
        } caption: {
            captionText
        }
        let output = element.render()
        #expect(output ==
            """
            <blockquote class="blockquote">\
            <p>\(quoteText)</p>\
            <footer class="blockquote-footer">\(captionText)</footer>\
            </blockquote>
            """
        )
    }
}
