//
//  Strikethrough.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `Strikethrough` element.
@Suite("Strikethrough Tests")
@MainActor
class StrikethroughTests: IgniteTestSuite {
    @Test("String content is wrapped in <s> tags")
    func stringContent() async throws {
        let element = Strikethrough("deleted text")
        let output = element.markupString()

        #expect(output == "<s>deleted text</s>")
    }

    @Test("Inline element content is rendered inside <s> tags")
    func inlineElementContent() async throws {
        let element = Strikethrough {
            Emphasis("important")
        }
        let output = element.markupString()

        #expect(output.contains("<s>"))
        #expect(output.contains("</s>"))
        #expect(output.contains("<em>important</em>"))
    }
}
