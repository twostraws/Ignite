//
// MarkdownOrderedLists.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Ignite
import Testing

/// Ordered lists retain their first number without changing ordinary list markup.
@Suite("Markdown Ordered List Tests")
struct MarkdownOrderedListTests {
    @Test("Ordered lists preserve a non-default starting number", arguments: [
        ("4. First\n5. Second", "<ol start=\"4\"><li>First</li><li>Second</li></ol>"),
        ("0. First\n1. Second", "<ol start=\"0\"><li>First</li><li>Second</li></ol>")
    ])
    func nonDefaultStart(markdown: String, expected: String) {
        let renderer = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(renderer.body == expected)
    }

    @Test("Lists starting at one preserve their existing HTML", arguments: [
        "1. First\n2. Second",
        "1. First\n99. Second"
    ])
    func defaultStart(markdown: String) {
        let renderer = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(renderer.body == "<ol><li>First</li><li>Second</li></ol>")
    }

    @Test("Only the first authored list number determines its start")
    func subsequentNumbers() {
        let markdown = """
        4. First
        99. Second
        8. Third
        """
        let renderer = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(renderer.body == "<ol start=\"4\"><li>First</li><li>Second</li><li>Third</li></ol>")
    }

    @Test("Nested ordered lists retain independent starting numbers")
    func nestedStarts() {
        let markdown = """
        4. Parent

           7. Child
           8. Another child

        5. Following
        """
        let renderer = MarkdownToHTML(markdown: markdown, removeTitleFromBody: false)

        #expect(renderer.body == """
        <ol start="4"><li>Parent<ol start="7"><li>Child</li><li>Another child</li></ol></li><li>Following</li></ol>
        """)
    }
}
