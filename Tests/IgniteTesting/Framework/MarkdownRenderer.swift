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

    @Test(
        "Markdown headers from string",
        arguments: ["# Header 1", "## Header 2", "### Header 3", "# Header with a #hashtag"]
    )
    func convertHeadersToHTML(markdown: String) async throws {
        let element = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        let expectedTag = "h\(numberOfHashtags(in: markdown))"
        let expectedContent = String(markdown.drop(while: { $0 == "#" }))
            .trimmingCharacters(in: .whitespacesAndNewlines)
        #expect(element.body == "<\(expectedTag)>\(expectedContent)</\(expectedTag)>")
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
}

extension MarkdownRendererTests {
    private func numberOfHashtags(in markdown: String) -> Int {
        return markdown.prefix(while: { $0 == "#" }).count
    }
}
