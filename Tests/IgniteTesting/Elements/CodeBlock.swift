//
//  CodeBlock.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

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
}
