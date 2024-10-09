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
struct TextTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Simple String Test")
    func test_simpleString() async throws {
        let element = Text("Hello")
        let output = element.render(context: publishingContext)

        #expect(output == "<p>Hello</p>")
    }
    @Test("Builder with Simple String Test")
    func test_simpleBuilderString() async throws {
        let element = Text {
            "Hello"
        }

        let output = element.render(context: publishingContext)

        #expect(output == "<p>Hello</p>")
    }
    @Test("Builder with Complex String Test")
    func test_complexBuilderString() {
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

        let output = element.render(context: publishingContext)

        #expect(output == "<p>Hello, <em>world</em><s> - <strong>this <u>is</u> a</strong> test!</s></p>")
    }
    @Test("Custom Font Test")
    func test_customFont() async throws {
        for font in Font.allCases {
            let element = Text("Hello").font(font)
            let output = element.render(context: publishingContext)

            if font == .lead {
                // This applies a paragraph class rather than a different tag.
                #expect(output == "<p class=\"lead\">Hello</p>")
            } else {
                #expect(output == "<\(font.rawValue)>Hello</\(font.rawValue)>")
            }
        }
    }
    @Test("Markdown Test")
    func test_markdown() async throws {
        let element = Text(markdown: "Text in *italics*, text in **bold**, and text in ***bold italics***.")
        let output = element.render(context: publishingContext)
        // swiftlint:disable line_length
        #expect(output == "<p>Text in <em>italics</em>, text in <strong>bold</strong>, and text in <em><strong>bold italics</strong></em>.</p>")
        // swiftlint:enable line_length
    }
}
