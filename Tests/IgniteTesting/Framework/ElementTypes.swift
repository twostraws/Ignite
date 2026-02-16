//
//  ElementTypes.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for default implementations on the element type protocols
/// (HTML, InlineElement, MarkupElement, BodyElement).
@Suite("ElementType Protocol Tests")
@MainActor
class ElementTypeTests: IgniteTestSuite {
    // MARK: - HTML.isEmpty

    @Test("EmptyHTML isEmpty returns true")
    func emptyHTMLIsEmpty() async throws {
        let element = EmptyHTML()
        #expect(element.isEmpty)
    }

    @Test("Text element isEmpty returns false")
    func textIsNotEmpty() async throws {
        let element = Text("Hello")
        #expect(!element.isEmpty)
    }

    @Test("HTMLCollection of only EmptyHTML is empty")
    func collectionOfEmptyHTMLIsEmpty() async throws {
        let collection = HTMLCollection([EmptyHTML(), EmptyHTML()])
        #expect(collection.isEmpty)
    }

    @Test("HTMLCollection with content is not empty")
    func collectionWithContentIsNotEmpty() async throws {
        let collection = HTMLCollection([Text("A"), Text("B")])
        #expect(!collection.isEmpty)
    }

    // MARK: - HTML.isText

    @Test("Text element isText returns true")
    func textElementIsText() async throws {
        let element = AnyHTML(Text("Hello"))
        #expect(element.isText)
    }

    @Test("Non-Text element isText returns false")
    func nonTextElementIsNotText() async throws {
        let element = AnyHTML(Divider())
        #expect(!element.isText)
    }

    // MARK: - HTML.isSection

    @Test("Section element isSection returns true")
    func sectionElementIsSection() async throws {
        let element = AnyHTML(Section { Text("Test") })
        #expect(element.isSection)
    }

    @Test("Non-Section element isSection returns false")
    func nonSectionElementIsNotSection() async throws {
        let element = AnyHTML(Text("Test"))
        #expect(!element.isSection)
    }

    // MARK: - HTML.columnWidth

    @Test("Default columnWidth is col")
    func defaultColumnWidthIsCol() async throws {
        let element = Text("Test")
        #expect(element.columnWidth == "col")
    }

    // MARK: - InlineElement.isEmpty

    @Test("EmptyInlineElement isEmpty returns true")
    func emptyInlineElementIsEmpty() async throws {
        let element = EmptyInlineElement()
        #expect(element.isEmpty)
    }

    @Test("Non-empty inline element isEmpty returns false")
    func nonEmptyInlineElementIsNotEmpty() async throws {
        let element = Emphasis("Hello")
        #expect(!element.isEmpty)
    }

    @Test("InlineElementCollection of only empty elements is empty")
    func inlineCollectionOfEmptyIsEmpty() async throws {
        let collection = InlineElementCollection([EmptyInlineElement(), EmptyInlineElement()])
        #expect(collection.isEmpty)
    }

    // MARK: - InlineElement.isImage

    @Test("Image element isImage returns true")
    func imageElementIsImage() async throws {
        let element = AnyInlineElement(Image("/test.jpg", description: "Test"))
        #expect(element.isImage)
    }

    @Test("Non-Image inline element isImage returns false")
    func nonImageElementIsNotImage() async throws {
        let element = AnyInlineElement(Emphasis("Hello"))
        #expect(!element.isImage)
    }

    // MARK: - MarkupElement.is() and .as()

    @Test("MarkupElement is() returns true for matching type")
    func markupElementIsMatchingType() async throws {
        let element = AnyHTML(Text("Hello"))
        #expect(element.is(Text.self))
    }

    @Test("MarkupElement is() returns false for non-matching type")
    func markupElementIsNotNonMatchingType() async throws {
        let element = AnyHTML(Text("Hello"))
        #expect(!element.is(Divider.self))
    }

    @Test("MarkupElement as() returns value for matching type")
    func markupElementAsMatchingType() async throws {
        let element = AnyHTML(Text("Hello"))
        let text = element.as(Text.self)
        #expect(text != nil)
    }

    @Test("MarkupElement as() returns nil for non-matching type")
    func markupElementAsNonMatchingType() async throws {
        let element = AnyHTML(Text("Hello"))
        let divider = element.as(Divider.self)
        #expect(divider == nil)
    }

    // MARK: - BodyElement.isPrimitive

    @Test("Built-in elements are primitive")
    func builtInElementsArePrimitive() async throws {
        #expect(Text("Hello").isPrimitive)
        #expect(Divider().isPrimitive)
    }
}
