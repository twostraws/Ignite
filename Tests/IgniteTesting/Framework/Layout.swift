//
// Layout.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing

@testable import Ignite

private struct HTMLLayout: Layout {
    var body: some HTML {
        Body {
            Text("HTML layout")
        }
    }
}

private struct DocumentLayout: Layout {
    var body: some Document {
        Body {
            Text("Document layout")
        }
    }
}

/// Tests for `Layout` compatibility.
@Suite("Layout Tests")
struct LayoutTests {
    @Test("HTML body layouts render as complete documents", .publishingContext())
    func htmlBodyLayoutRendersAsCompleteDocument() async throws {
        let output = HTMLLayout().documentMarkupString()

        #expect(output.hasPrefix("<!doctype html>"))
        #expect(output.contains("<body"))
        #expect(output.contains("HTML layout"))
    }

    @Test("Document body layouts render as complete documents", .publishingContext())
    func documentBodyLayoutRendersAsCompleteDocument() async throws {
        let output = DocumentLayout().documentMarkupString()

        #expect(output.hasPrefix("<!doctype html>"))
        #expect(output.contains("<body"))
        #expect(output.contains("Document layout"))
    }
}
