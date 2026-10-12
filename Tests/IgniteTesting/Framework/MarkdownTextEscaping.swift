//
// MarkdownTextEscaping.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import SwiftSoup
import Testing

@testable import Ignite

/// Escaped Markdown prose must remain text after the generated HTML is parsed.
@Suite("Markdown Text Escaping Tests")
struct MarkdownTextEscapingTests {
    @Test("Markdown escapes and entities remain literal text", arguments: [
        (#"Use \<br/> literally."#, "Use <br/> literally."),
        ("Use &lt;br/&gt; literally.", "Use <br/> literally."),
        ("Literal &amp;lt; and &amp;#60;", "Literal &lt; and &#60;"),
        ("A &amp; B > C", "A & B > C"),
        ("Ordinary text", "Ordinary text")
    ])
    func literalText(markdown: String, expected: String) throws {
        let renderer = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)
        let document = try SwiftSoup.parseBodyFragment(renderer.body)
        let paragraph = try #require(document.select("p").first())

        #expect(try paragraph.text() == expected)
        #expect(paragraph.children().isEmpty())
    }

    @Test("Escaped text preserves surrounding Markdown formatting")
    func formattingRemainsIntact() throws {
        let renderer = MarkdownToHTML(
            markdown: #"**Use \<br/> literally.** and [literal &amp;lt;](/guide)."#,
            removeTitleFromBody: false
        )
        let document = try SwiftSoup.parseBodyFragment(renderer.body)
        let strong = try #require(document.select("strong").first())
        let link = try #require(document.select("a").first())

        #expect(try strong.text() == "Use <br/> literally.")
        #expect(strong.children().isEmpty())
        #expect(try link.text() == "literal &lt;")
        #expect(try link.attr("href") == "/guide")
    }

    @Test("Ordinary Markdown smart typography is preserved")
    func smartTypographyRemainsIntact() throws {
        let renderer = MarkdownToHTML(
            markdown: #"She said "Hello"..."#,
            removeTitleFromBody: false
        )

        #expect(try SwiftSoup.parseBodyFragment(renderer.body).text() == "She said “Hello”…")
    }
}
