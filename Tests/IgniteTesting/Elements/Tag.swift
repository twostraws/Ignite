//
//  Tag.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Tag` element.
@Suite("Tag Tests")
@MainActor
class TagTests: IgniteTestSuite {
    @Test("Basic Tag", arguments: ["tag_1", "tag_2", "tag_3"])
    func basicTag(tagName: String) async throws {
        // Given
        let element = Tag(tagName)
        // When
        let output = element.render()

        // Then
        #expect(output == "<\(tagName)></\(tagName)>")
    }

    @Test("Tag with single element", arguments: ["tag_1", "tag_2", "tag_3"])
    func tagWithSingleElement(tagName: String) async throws {
        // Given
        let htmlElement = Span("Test Span")
        let element = Tag(tagName, content: htmlElement)

        // When
        let output = element.render()

        // Then
        #expect(output == "<\(tagName)><span>Test Span</span></\(tagName)>")
    }

    @Test("Tag with multiple elements", arguments: ["tag_1", "tag_2", "tag_3"])
    func tagWithMultipleElements(tagName: String) async throws {
        // Given
        let element = Tag(tagName) {
            Span("Test Span 1")
            Span("Test Span 2")
        }

        // When
        let output = element.render()

        // Then
        #expect(output == "<\(tagName)><span>Test Span 1</span><span>Test Span 2</span></\(tagName)>")
    }
}
