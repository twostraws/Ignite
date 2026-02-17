//
//  Emphasis.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Emphasis` element.
@Suite("Emphasis Tests")
@MainActor
class EmphasisTests: IgniteTestSuite {
    @Test("Emphasis")
    func simpleEmphasis() async throws {
        let element = Emphasis("Although Markdown is still easier, to be honest! ")
        let output = element.markupString()

        #expect(output == "<em>Although Markdown is still easier, to be honest! </em>")
    }

    @Test("Emphasis with builder initializer wrapping inline element")
    func builderWithInlineElement() async throws {
        let element = Emphasis {
            Strong("very important")
        }
        let output = element.markupString()

        #expect(output == "<em><strong>very important</strong></em>")
    }

    @Test("Emphasis with multiple children via builder")
    func builderWithMultipleChildren() async throws {
        let element = Emphasis {
            "Hello "
            Strong("world")
        }
        let output = element.markupString()

        #expect(output.contains("Hello "))
        #expect(output.contains("<strong>world</strong>"))
        #expect(output.hasPrefix("<em>"))
        #expect(output.hasSuffix("</em>"))
    }
}
