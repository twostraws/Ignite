//
//  InlineElementBuilder.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `InlineElementBuilder` result builder.
@Suite("InlineElementBuilder Tests")
@MainActor
class InlineElementBuilderTests: IgniteTestSuite {
    private func build(@InlineElementBuilder content: () -> some InlineElement) -> some InlineElement {
        content()
    }

    @Test("Single element passes through")
    func singleElement() async throws {
        let result = build { Emphasis("Hello") }
        #expect(result.markupString() == "<em>Hello</em>")
    }

    @Test("Multiple elements combine into collection")
    func multipleElements() async throws {
        let result = build {
            Emphasis("Bold")
            Strong("Strong")
        }
        let output = result.markupString()
        #expect(output.contains("<em>Bold</em>"))
        #expect(output.contains("<strong>Strong</strong>"))
    }

    @Test("Empty block produces empty output")
    func emptyBlock() async throws {
        let result = build {}
        #expect(result.markupString() == "")
    }

    @Test("Optional nil produces empty output")
    func optionalNil() async throws {
        let show = false
        let result = build {
            if show {
                Emphasis("Hidden")
            }
        }
        #expect(result.markupString() == "")
    }

    @Test("If-else selects correct branch")
    func ifElseSelectsCorrectBranch() async throws {
        let useFirst = true
        let result = build {
            if useFirst {
                Emphasis("First")
            } else {
                Emphasis("Second")
            }
        }
        #expect(result.markupString() == "<em>First</em>")
    }

    @Test("For loop produces all elements")
    func forLoop() async throws {
        let words = ["one", "two"]
        let result = build {
            for word in words {
                Emphasis(word)
            }
        }
        let output = result.markupString()
        #expect(output.contains("<em>one</em>"))
        #expect(output.contains("<em>two</em>"))
    }
}
