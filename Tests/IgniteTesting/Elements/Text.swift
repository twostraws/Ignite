//
// Text.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `Text` element.
@Suite("Text Tests")
@MainActor class TextTests: IgniteTestSuite {
    @Test("Simple String")
    func simpleString() async throws {
        let element = Text("Hello")
        let output = element.render()
        #expect(output == "<p>Hello</p>")
    }

    @Test("Builder with Simple String")
    @MainActor func test_simpleBuilderString() async throws {
        let element = Text { "Hello" }
        let output = element.render()
        #expect(output == "<p>Hello</p>")
    }

    @Test("Builder with Complex String")
    func complexBuilderString() {
        let element = Text {
            "Hello, "
            Emphasis("world")

            Strikethrough {
                " - "
                Strong {
                    "this "
                    Underline("is")
                    " a"
                }
                " test!"
            }
        }

        let output = element.render()

        #expect(output == """
        <p>Hello, <em>world</em><s> - <strong>this <u>is</u> a</strong> test!</s></p>
        """)
    }

    @Test("Custom Font", arguments: Font.Style.allCases)
    func customFont(font: Font.Style) async throws {
        let element = Text("Hello").font(font)
        let output = element.render()

        if font == .lead {
            // This applies a paragraph class rather than a different tag.
            #expect(output == "<p class=\"lead\">Hello</p>")
        } else {
            #expect(output == "<\(font.rawValue)>Hello</\(font.rawValue)>")
        }
    }

    @Test("Markdown")
    func markdown() async throws {
        let element = Text(markdown: "*i*, **b**, and ***b&i***")
        let output = element.render()

        #expect(output == """
        <p><em>i</em>, <strong>b</strong>, and <em><strong>b&i</strong></em></p>
        """)
    }

    @Test("Strikethrough")
    func strikethrough() async throws {
        // Given
        let element = Text {
            Strikethrough {
                "There will be a few tickets available at the box office tonight."
            }
        }
        // When
        let output = element.render()
        // Then
        #expect(output == """
        <p><s>There will be a few tickets available at the box office tonight.</s></p>
        """)
    }
}
