//
// MarkdownImageEscaping.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import SwiftSoup
import Testing

@testable import Ignite

/// Markdown image attributes contain decoded text, not pre-encoded HTML.
@Suite("Markdown Image Escaping Tests")
struct MarkdownImageEscapingTests {
    @Test("Markdown image descriptions survive HTML parsing", arguments: [
        ("Tap the &quot;Save&quot; button", #"Tap the "Save" button"#),
        ("Tap the &#34;Save&#34; button", #"Tap the "Save" button"#),
        ("Literal &amp;quot; and &amp;lt;", "Literal &quot; and &lt;"),
        ("A &amp; B and &lt;tag&gt;", "A & B and <tag>"),
        (#"Tap the "Save" button"#, "Tap the “Save” button"),
        ("Ordinary description", "Ordinary description")
    ])
    func imageDescription(markdown: String, expected: String) throws {
        let source = "https://example.com/image.png"
        let renderer = MarkdownToHTML(
            markdown: "![\(markdown)](\(source))",
            removeTitleFromBody: false
        )
        let document = try SwiftSoup.parseBodyFragment(renderer.body)
        let image = try #require(document.select("img").first())

        #expect(try image.attr("alt") == expected)
        #expect(try image.attr("src") == source)
        #expect(try image.attr("class") == "img-fluid")
        #expect(image.getAttributes()?.size() == 3)
    }

    @Test("Markdown image sources preserve decoded attribute values", arguments: [
        ("/image.png?label=&quot;Save&quot;", #"/image.png?label="Save""#),
        ("/image.png?literal=&amp;copy;", "/image.png?literal=&copy;"),
        ("/image.png?width=400&amp;height=200", "/image.png?width=400&height=200"),
        ("/image.png", "/image.png")
    ])
    func imageSource(markdown: String, expected: String) throws {
        let renderer = MarkdownToHTML(markdown: "![Example](\(markdown))", removeTitleFromBody: false)
        let document = try SwiftSoup.parseBodyFragment(renderer.body)
        let image = try #require(document.select("img").first())

        #expect(try image.attr("src") == expected)
        #expect(try image.attr("alt") == "Example")
        #expect(try image.attr("class") == "img-fluid")
        #expect(image.getAttributes()?.size() == 3)
    }
}
