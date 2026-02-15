//
//  DocumentBuilder.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `DocumentBuilder` and `DocumentElementBuilder` result builders.
@Suite("DocumentBuilder Tests")
@MainActor
class DocumentBuilderTests: IgniteTestSuite {
    private func buildDocument(@DocumentBuilder content: () -> some Document) -> some Document {
        content()
    }

    // MARK: - DocumentBuilder

    @Test("Head and Body produce a valid document")
    func headAndBody() async throws {
        let doc = buildDocument {
            Head()
            Body()
        }
        let output = doc.markupString()
        #expect(output.hasPrefix("<!doctype html>"))
        #expect(output.contains("<html"))
        #expect(output.contains("</html>"))
    }

    @Test("Body-only produces document with default head")
    func bodyOnly() async throws {
        let doc = buildDocument {
            Body()
        }
        let output = doc.markupString()
        #expect(output.hasPrefix("<!doctype html>"))
        #expect(output.contains("<html"))
    }

    @Test("Existing document passes through")
    func existingDocumentPassthrough() async throws {
        let original = PlainDocument(head: Head(), body: Body())
        let doc = buildDocument { original }
        let output = doc.markupString()
        #expect(output.hasPrefix("<!doctype html>"))
    }

    // MARK: - DocumentElementBuilder

    @Test("DocumentElementBuilder with Head and Body returns tuple")
    func documentElementBuilderHeadAndBody() async throws {
        let doc = PlainDocument {
            Head()
            Body()
        }
        let output = doc.markupString()
        #expect(output.hasPrefix("<!doctype html>"))
        #expect(output.contains("<head"))
        #expect(output.contains("<body"))
    }

    @Test("DocumentElementBuilder with Body-only provides default head")
    func documentElementBuilderBodyOnly() async throws {
        let doc = PlainDocument {
            Body()
        }
        let output = doc.markupString()
        #expect(output.hasPrefix("<!doctype html>"))
        #expect(output.contains("<body"))
    }
}
