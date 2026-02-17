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

        let output = element.markupString()

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

        let output = element.markupString()

        #expect(output == """
        <blockquote class="blockquote">\
        <p>\(quoteText)</p>\
        <footer class="blockquote-footer">\(captionText)</footer>\
        </blockquote>
        """)
    }

    @Test("Quote with multiple children renders all content")
    func multipleChildren() async throws {
        let element = Quote {
            Text("First line")
            Text("Second line")
        }

        let output = element.markupString()

        #expect(output.contains("<p>First line</p>"))
        #expect(output.contains("<p>Second line</p>"))
        #expect(output.hasPrefix("<blockquote"))
        #expect(output.hasSuffix("</blockquote>"))
    }

    @Test("Quote caption with inline element renders styled caption")
    func captionWithInlineElement() async throws {
        let element = Quote {
            Text("To be or not to be")
        } caption: {
            Emphasis("Shakespeare")
        }

        let output = element.markupString()

        #expect(output.contains("<footer class=\"blockquote-footer\">"))
        #expect(output.contains("<em>Shakespeare</em>"))
    }
}
