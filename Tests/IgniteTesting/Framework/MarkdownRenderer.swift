//
//  MarkdownRenderer.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for `MarkdownRenderer`.
@Suite("MarkdownRenderer Tests")
@MainActor
struct MarkdownRendererTests {

    @Test("Markdown metadata is processed")
    func metadataIsProcessed() async throws {
        let element = MarkdownToHTML(
            markdown: """
            ---
            title: Example Title
            ---
            Test content
            """,
            removeTitleFromBody: false
        )

        #expect(element.body == "<p>Test content</p>")
        #expect(element.metadata["title"] == "Example Title")
    }

    @Test(
        "Markdown headings from string",
        arguments: ["# Heading 1", "## Heading 2", "### Heading 3", "# Heading with a #hashtag"]
    )
    func convertHeadingsToHTML(markdown: String) async throws {
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        let expectedTag = "h\(numberOfHashtags(in: markdown))"
        let expectedContent = String(markdown.drop(while: { $0 == "#" }))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(element.body == "<\(expectedTag)>\(expectedContent)</\(expectedTag)>")
    }

    @Test("Markdown heading remove title from body")
    func removeTitleFromBody() async throws {
        let element = MarkdownToHTML(
            markdown: "# Test Heading\n\nTest content",
            removeTitleFromBody: true
        )

        #expect(element.body == "<p>Test content</p>")
    }

    @Test("Markdown paragraphs from string", arguments: ["Paragraph one\n\nParagraph two"])
    func convertParagraphsToHTML(markdown: String) async throws {
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        let paragraphs = markdown.split(separator: "\n\n")
        let expectedHTML = paragraphs
            .map {
                "<p>\($0)</p>"
            }
            .joined()
        #expect(element.body == "\(expectedHTML)")
    }

    @Test("Markdown block quotes from string", arguments: ["> Here is an example quote"])
    func convertBlockQuotesToHTML(markdown: String) async throws {
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        let content = markdown.replacingOccurrences(of: "> ", with: "")
        #expect(element.body == "<blockquote><p>\(content)</p></blockquote>")
    }

    @Test("Markdown image from string", arguments: ["Here is an ![Image description](path/to/example/image.jpg)"])
    func convertImageToHTML(markdown: String) async throws {
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        let expectedImageHTML = "<img src=\"path/to/example/image.jpg\" alt=\"Image description\" class=\"img-fluid\">"
        #expect(element.body == "<p>Here is an \(expectedImageHTML)</p>")
    }

    @Test("Markdown code block from string", arguments: ["Here is some `var code = \"great\"`"])
    func convertCodeBlockToHTML(markdown: String) async throws {
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == "<p>Here is some <code>var code = \"great\"</code></p>")
    }

    @Test("Markdown emphasis from string", arguments: ["Here is some *emphasized* text"])
    func convertEmphasisToHTML(markdown: String) async throws {
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == "<p>Here is some <em>emphasized</em> text</p>")
    }

    @Test("Markdown link from string", arguments: ["Here is a [link](https://example.com)"])
    func convertLinkToHTML(markdown: String) async throws {
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == "<p>Here is a <a href=\"https://example.com\">link</a></p>")
    }

    @Test("Markdown list from string")
    func convertListToHTML() async throws {
        let markdown = """
        - Item 1
        - Item 2
        """
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == "<ul><li>Item 1</li><li>Item 2</li></ul>")
    }

    @Test("Markdown ordered list from string")
    func convertOrderedListToHTML() async throws {
        let markdown = """
        1. Item 1
        2. Item 2
        """
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == "<ol><li>Item 1</li><li>Item 2</li></ol>")
    }

    @Test("Markdown strikethrough from string")
    func convertStrikethroughToHTML() async throws {
        let markdown = "Example text with some of it ~crossed out~"
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == "<p>Example text with some of it <s>crossed out</s></p>")
    }

    @Test("Markdown strong from string")
    func convertStrongToHTML() async throws {
        let markdown = "Example of **strong** text"
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == "<p>Example of <strong>strong</strong> text</p>")
    }

    @Test("Markdown table from string")
    func convertTableToHTML() async throws {
        let markdown = """
        | Title 1 | Title 2 |
        | --- | --- |
        | Content 1 | Content 2|
        """
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == """
        <table class="table">\
        <thead>\
        <th scope="col">Title 1</th>\
        <th scope="col">Title 2</th>\
        </thead>\
        <tbody>\
        <tr>\
        <td>Content 1</td>\
        <td>Content 2</td>\
        </tr>\
        </tbody>\
        </table>
        """)
    }

    @Test("Markdown thematic break from string")
    func convertThematicBreakToHTML() async throws {
        let markdown = """
        Text above

        ---

        Text below
        """
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(element.body == "<p>Text above</p><hr /><p>Text below</p>")
    }
}

extension MarkdownRendererTests {
    private func numberOfHashtags(in markdown: String) -> Int {
        return markdown.prefix(while: { $0 == "#" }).count
    }
}
