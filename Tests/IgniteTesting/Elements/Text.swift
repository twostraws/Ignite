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
        let output = element.markupString()
        #expect(output == "<p>Hello</p>")
    }

    @Test("Builder with Simple String")
    @MainActor func test_simpleBuilderString() async throws {
        let element = Text { "Hello" }
        let output = element.markupString()
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

        let output = element.markupString()

        #expect(output == """
        <p>Hello, <em>world</em><s> - <strong>this <u>is</u> a</strong> test!</s></p>
        """)
    }

    @Test("Custom Font", arguments: Font.Style.allCases)
    func customFont(font: Font.Style) async throws {
        let element = Text("Hello").font(font)
        let output = element.markupString()

        if FontStyle.classBasedStyles.contains(font), let sizeClass = font.sizeClass {
            // This applies a paragraph class rather than a different tag.
            #expect(output == "<p class=\"\(sizeClass)\">Hello</p>")
        } else {
            #expect(output == "<\(font.rawValue)>Hello</\(font.rawValue)>")
        }
    }

    @Test("Markdown")
    func markdown() async throws {
        let element = Text(markdown: "*i*, **b**, and ***b&i***")
        let output = element.markupString()

        #expect(output == """
        <p><em>i</em>, <strong>b</strong>, and <em><strong>b&amp;i</strong></em></p>
        """)
    }
    
    @Test("Markdown rendering disappearing headings")
    func markdownRenderingDisappearingHeadings() async throws {
        let element = Text(markdown: """
        ## Heading 1
        Body text 1
        ## Heading 2
        Body text 2
        """)
        let output = element.markupString()
        #expect(output.contains("<h2>Heading 1</h2>"))
        #expect(output.contains("<h2>Heading 2</h2>"))
    }
    
    @Test("Markdown rendering invalid paragraphs")
    func markdownRenderingInvalidParagraphs() async throws {
        let element = Text(markdown: """
        ## Heading 1
        Text 1
        
        Text 2
        
        ## Heading 2
        Text 3
        """)
        let output = element.markupString()
        #expect(output.contains("<p>Text 1</p>"))
        #expect(output.contains("<p>Text 2</p>"))
        #expect(output.contains("<p>Text 3</p>"))
        #expect(output.contains("<p></p>") == false)
    }

    @Test("Markdown rendering preserves block structure")
    func markdownRenderingPreservesBlockStructure() async throws {
        let element = Text(markdown: """
        ## Heading
        - Item 1
        - Item 2
        """)
        let output = element.markupString()
        #expect(output == "<div><h2>Heading</h2><ul><li>Item 1</li><li>Item 2</li></ul></div>")
    }

    @Test("Markup parser preserves block Markdown")
    func markupParserPreservesBlockMarkdown() async throws {
        let element = Text(
            markup: """
            ## Heading 1
            Body text 1
            ## Heading 2
            Body text 2
            """,
            parser: MarkdownToHTML.self
        )
        let output = element.markupString()
        #expect(output == "<div><h2>Heading 1</h2><p>Body text 1</p><h2>Heading 2</h2><p>Body text 2</p></div>")
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
        let output = element.markupString()
        // Then
        #expect(output == """
        <p><s>There will be a few tickets available at the box office tonight.</s></p>
        """)
    }
}
