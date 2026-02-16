//
//  InlineElementCollection.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `InlineElementCollection` flattening and iteration behavior.
@Suite("InlineElementCollection Tests")
@MainActor
struct InlineElementCollectionTests {
    @Test("Filters out EmptyInlineElement instances")
    func filtersEmptyInlineElements() async throws {
        let collection = InlineElementCollection([Emphasis("A"), EmptyInlineElement(), Emphasis("B")])
        #expect(collection.elements.count == 2)
    }

    @Test("Flattens AnyInlineElement to reveal wrapped element")
    func flattensAnyInlineElement() async throws {
        let wrapped = AnyInlineElement(Emphasis("Hello"))
        let collection = InlineElementCollection([wrapped])
        #expect(collection.elements.count == 1)
        #expect(collection.elements.first is Emphasis)
    }

    @Test("Flattens nested InlineElementCollection")
    func flattensNestedCollection() async throws {
        let inner = InlineElementCollection([Emphasis("A"), Emphasis("B")])
        let outer = InlineElementCollection([inner])
        #expect(outer.elements.count == 2)
    }

    @Test("Sequence iteration yields all elements")
    func sequenceIterationYieldsAll() async throws {
        let collection = InlineElementCollection([Emphasis("A"), Emphasis("B"), Emphasis("C")])
        var count = 0
        for _ in collection { count += 1 }
        #expect(count == 3)
    }
}
