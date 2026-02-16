//
//  CodeBlock.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// A site configured with a specific line number visibility for CodeBlock tests.
private struct LineNumbersSite: Site {
    var name = "Test"
    var url = URL(static: "https://www.example.com")
    var homePage = TestPage()
    var layout = EmptyLayout()
    var syntaxHighlighterConfiguration: SyntaxHighlighterConfiguration

    init(lineNumberVisibility: SyntaxHighlighterConfiguration.LineNumberVisibility = .visible) {
        self.syntaxHighlighterConfiguration = SyntaxHighlighterConfiguration(
            languages: [],
            lineNumberVisibility: lineNumberVisibility
        )
    }
}

/// Tests for the `CodeBlock` element.
@Suite("CodeBlock Tests")
@MainActor
class CodeBlockTests: IgniteTestSuite {
    @Test("Rendering a code block")
    func codeBlockTest() {
        let element = CodeBlock { """
        import Foundation
        struct CodeBlockTest {
            let name: String
        }
        let test = CodeBlockTest(name: "Swift")
        """ }

        let output = element.markupString()

        #expect(output == """
        <pre><code>import Foundation
        struct CodeBlockTest {
            let name: String
        }
        let test = CodeBlockTest(name: "Swift")</code></pre>
        """)
    }

    @Test("Code block with language adds language class to code element")
    func codeBlockWithLanguage() {
        let element = CodeBlock(.swift) { "let x = 1" }
        let output = element.markupString()
        #expect(output.contains("class=\"language-swift\""))
        #expect(output.contains("let x = 1"))
    }

    @Test("Code block without language omits language class")
    func codeBlockWithoutLanguage() {
        let element = CodeBlock { "echo hello" }
        let output = element.markupString()
        #expect(!output.contains("language-"))
    }

    @Test("Code block with highlighted lines adds data-line attribute")
    func highlightedLines() {
        let element = CodeBlock(.swift) { "line1\nline2\nline3" }
            .highlightedLines(1, 3)
        let output = element.markupString()
        #expect(output.contains("data-line=\"1,3\""))
    }

    @Test("Code block with highlighted ranges adds data-line attribute with range")
    func highlightedRanges() {
        let element = CodeBlock(.swift) { "a\nb\nc\nd" }
            .highlightedRanges(1...3)
        let output = element.markupString()
        #expect(output.contains("data-line=\"1-3\""))
    }

    @Test("Code block with mixed highlighted lines and ranges combines data-line values")
    func mixedHighlightedLinesAndRanges() {
        let element = CodeBlock(.swift) { "a\nb\nc\nd\ne" }
            .highlightedLines(1, 5, ranges: 2...4)
        let output = element.markupString()
        #expect(output.contains("data-line=\"1,5,2-4\""))
    }

    // MARK: - Line number visibility matrix

    @Test("Site visible + element hidden adds no-line-numbers class")
    func siteVisibleElementHidden() throws {
        try PublishingContext.initialize(for: LineNumbersSite(), from: #filePath)
        let element = CodeBlock(.swift) { "let x = 1" }
            .lineNumberVisibility(.hidden)
        let output = element.markupString()
        #expect(output.contains("no-line-numbers"))
    }

    @Test("Site hidden + element visible adds line-numbers class")
    func siteHiddenElementVisible() throws {
        try PublishingContext.initialize(for: LineNumbersSite(lineNumberVisibility: .hidden), from: #filePath)
        let element = CodeBlock(.swift) { "let x = 1" }
            .lineNumberVisibility(.visible)
        let output = element.markupString()
        #expect(output.contains("line-numbers"))
        #expect(!output.contains("data-start"))
    }

    @Test("Site hidden + element visible with custom start adds data-start")
    func siteHiddenElementVisibleCustomStart() throws {
        try PublishingContext.initialize(for: LineNumbersSite(lineNumberVisibility: .hidden), from: #filePath)
        let element = CodeBlock(.swift) { "let x = 1" }
            .lineNumberVisibility(.visible(firstLine: 10, linesWrap: false))
        let output = element.markupString()
        #expect(output.contains("data-start=\"10\""))
    }

    @Test("Site hidden + element visible with wrapping adds pre-wrap style")
    func siteHiddenElementVisibleWrapping() throws {
        try PublishingContext.initialize(for: LineNumbersSite(lineNumberVisibility: .hidden), from: #filePath)
        let element = CodeBlock(.swift) { "let x = 1" }
            .lineNumberVisibility(.visible(firstLine: 1, linesWrap: true))
        let output = element.markupString()
        #expect(output.contains("white-space: pre-wrap"))
    }

    @Test("Both visible with different start lines adds data-start for element value")
    func bothVisibleDifferentStart() throws {
        try PublishingContext.initialize(for: LineNumbersSite(), from: #filePath)
        let element = CodeBlock(.swift) { "let x = 1" }
            .lineNumberVisibility(.visible(firstLine: 5, linesWrap: false))
        let output = element.markupString()
        #expect(output.contains("data-start=\"5\""))
    }

    @Test("Both visible with different wrapping adds white-space style")
    func bothVisibleDifferentWrapping() throws {
        try PublishingContext.initialize(for: LineNumbersSite(), from: #filePath)
        let element = CodeBlock(.swift) { "let x = 1" }
            .lineNumberVisibility(.visible(firstLine: 1, linesWrap: true))
        let output = element.markupString()
        #expect(output.contains("white-space: pre-wrap"))
    }
}
