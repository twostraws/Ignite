//
//  HTMLBuilder.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `HTMLBuilder` result builder.
@Suite("HTMLBuilder Tests")
class HTMLBuilderTests: IgniteTestSuite {
    private func build(@HTMLBuilder content: () -> some HTML) -> some HTML {
        content()
    }

    @Test("Single element passes through", .publishingContext())
    func singleElement() async throws {
        let result = build { Text("Hello") }
        #expect(result.markupString() == "<p>Hello</p>")
    }

    @Test("Multiple elements combine into collection", .publishingContext())
    func multipleElements() async throws {
        let result = build {
            Text("A")
            Text("B")
        }
        #expect(result.markupString() == "<p>A</p><p>B</p>")
    }

    @Test("Empty block produces empty output", .publishingContext())
    func emptyBlock() async throws {
        let result = build {}
        #expect(result.markupString() == "")
    }

    @Test("Optional nil produces empty output", .publishingContext())
    func optionalNil() async throws {
        let show = false
        let result = build {
            if show {
                Text("Hidden")
            }
        }
        #expect(result.markupString() == "")
    }

    @Test("Optional non-nil produces content", .publishingContext())
    func optionalNonNil() async throws {
        let show = true
        let result = build {
            if show {
                Text("Visible")
            }
        }
        #expect(result.markupString() == "<p>Visible</p>")
    }

    @Test("If-else true branch", .publishingContext())
    func ifElseTrueBranch() async throws {
        let condition = true
        let result = build {
            if condition {
                Text("Yes")
            } else {
                Text("No")
            }
        }
        #expect(result.markupString() == "<p>Yes</p>")
    }

    @Test("If-else false branch", .publishingContext())
    func ifElseFalseBranch() async throws {
        let condition = false
        let result = build {
            if condition {
                Text("Yes")
            } else {
                Text("No")
            }
        }
        #expect(result.markupString() == "<p>No</p>")
    }

    @Test("For loop produces all elements", .publishingContext())
    func forLoop() async throws {
        let items = ["A", "B", "C"]
        let result = build {
            for item in items {
                Text(item)
            }
        }
        #expect(result.markupString() == "<p>A</p><p>B</p><p>C</p>")
    }

    @Test("Mixed content combines correctly", .publishingContext())
    func mixedContent() async throws {
        let result = build {
            Text("First")
            Divider()
            Text("Last")
        }
        let output = result.markupString()
        #expect(output.contains("<p>First</p>"))
        #expect(output.contains("<hr"))
        #expect(output.contains("<p>Last</p>"))
    }
}
