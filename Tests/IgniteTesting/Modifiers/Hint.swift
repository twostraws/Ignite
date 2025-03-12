//
//  Hint.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Hint` modifier.
@Suite("Hint Tests")
@MainActor
class HintTests: IgniteTestSuite {
    @Test("Markdown Hint")
    func markdownHint() async throws {
        let element = Text {
            Span("Hover over me")
                .hint(markdown: "Why, *hello* there!")
        }

        let output = element.render()

        #expect(output == """
        <p><span data-bs-toggle="tooltip" \
        data-bs-title="Why, <em>hello</em> there!" \
        data-bs-html="true">Hover over me\
        </span>\
        </p>
        """)
    }

    @Test("HMTL Hint")
    func htmlHint() async throws {
        let element = Text {
            Span("Hover over me")
                .hint(html: "www.example.com")
        }

        let output = element.render()

        #expect(output == """
        <p><span data-bs-toggle="tooltip" \
        data-bs-title="www.example.com" \
        data-bs-html="true">Hover over me\
        </span>\
        </p>
        """)
    }

    @Test("HMTL Hint")
    func textHint() async throws {
        let element = Text {
            Span("Hover over me")
                .hint(text: "Why, hello there!")
        }

        let output = element.render()

        #expect(output == """
        <p><span data-bs-toggle="tooltip" \
        data-bs-title="Why, hello there!">Hover over me\
        </span>\
        </p>
        """)
    }
}
