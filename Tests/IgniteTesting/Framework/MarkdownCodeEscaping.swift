//
// MarkdownCodeEscaping.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Literal code must survive HTML parsing without becoming markup or entities.
@Suite("Markdown Code Escaping Tests")
struct MarkdownCodeEscapingTests {
    @Test("Inline code preserves literal HTML characters", arguments: [
        ("Array<String>", "Array&lt;String&gt;"),
        ("<strong>literal</strong>", "&lt;strong&gt;literal&lt;/strong&gt;"),
        ("a && b &lt; c &#60; d", "a &amp;&amp; b &amp;lt; c &amp;#60; d"),
        ("let title = \"Hello\"", "let title = \"Hello\"")
    ])
    func inlineCode(code: String, expected: String) {
        let renderer = MarkdownToHTML(markdown: "Use `\(code)` here.", removeTitleFromBody: false)

        #expect(renderer.body == "<p>Use <code>\(expected)</code> here.</p>")
    }

    @Test("Fenced code preserves literal HTML characters with and without a language", arguments: ["", "Swift"])
    func fencedCode(language: String) {
        let markdown = """
        ```\(language)
        let values: Array<String> = []
        <strong>literal</strong>
        a && b &lt; c &#60; d
        ```
        """
        let renderer = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)
        let codeTag = language.isEmpty ? "<code>" : "<code class=\"language-swift\">"

        #expect(renderer.body == """
        <pre>\(codeTag)let values: Array&lt;String&gt; = []
        &lt;strong&gt;literal&lt;/strong&gt;
        a &amp;&amp; b &amp;lt; c &amp;#60; d
        </code></pre>
        """)
    }

    @Test("Text Markdown uses escaped code", .publishingContext())
    func markdownText() {
        let text = Text(markdown: "Use `Array<String>` and `&lt;`.")

        #expect(text.markupString() == "<p>Use <code>Array&lt;String&gt;</code> and <code>&amp;lt;</code>.</p>")
    }

    @Test("Ordinary Markdown formatting is unchanged")
    func ordinaryMarkdown() {
        let renderer = MarkdownToHTML(markdown: "Use **bold** and `let count = 3`.", removeTitleFromBody: false)

        #expect(renderer.body == "<p>Use <strong>bold</strong> and <code>let count = 3</code>.</p>")
    }

    @Test("Intentional inline and block HTML remains HTML")
    func intentionalHTML() {
        let inline = MarkdownToHTML(markdown: "Use <strong>bold</strong> here.", removeTitleFromBody: false)
        let block = MarkdownToHTML(markdown: "<div>Raw <em>HTML</em></div>", removeTitleFromBody: false)

        #expect(inline.body == "<p>Use <strong>bold</strong> here.</p>")
        #expect(block.body.trimmingCharacters(in: .whitespacesAndNewlines) == "<div>Raw <em>HTML</em></div>")
    }
}
