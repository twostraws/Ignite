//
//  Code.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Code` element.
@Suite("Code Tests")
@MainActor
class CodeTests: IgniteTestSuite {
    @Test("Inline code formatting")
    func inlineCode() async throws {
        let element = Code("background-color")
        let output = element.markupString()
        #expect(output == "<code>background-color</code>")
    }

    @Test("Code preserves angle brackets in content")
    func angleBrackets() async throws {
        let element = Code("Array&lt;Int&gt;")
        let output = element.markupString()
        #expect(output == "<code>Array&lt;Int&gt;</code>")
    }

    @Test("Code with empty string renders empty code element")
    func emptyContent() async throws {
        let element = Code("")
        let output = element.markupString()
        #expect(output == "<code></code>")
    }

    @Test("Code with custom class includes class attribute")
    func customClass() async throws {
        let element = Code("let x = 1").class("highlight")
        let output = element.markupString()
        #expect(output.contains("class=\"highlight\""))
        #expect(output.contains("let x = 1"))
    }

    @Test("Code with ID includes id attribute")
    func idAttribute() async throws {
        let element = Code("print()").id("code-sample")
        let output = element.markupString()
        #expect(output.contains("id=\"code-sample\""))
    }
}
