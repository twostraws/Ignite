//
//  HTMLCollection.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `HTMLCollection` flattening and iteration behavior.
@Suite("HTMLCollection Tests")
struct HTMLCollectionTests {
    @Test("Filters out EmptyHTML elements", .publishingContext())
    func filtersEmptyHTML() async throws {
        let collection = HTMLCollection([Text("A"), EmptyHTML(), Text("B")])
        #expect(collection.elements.count == 2)
    }

    @Test("Flattens AnyHTML to reveal wrapped element", .publishingContext())
    func flattensAnyHTML() async throws {
        let wrapped = AnyHTML(Text("Hello"))
        let collection = HTMLCollection([wrapped])
        #expect(collection.elements.count == 1)
        #expect(collection.elements.first is Text)
    }

    @Test("Flattens nested HTMLCollection", .publishingContext())
    func flattensNestedCollection() async throws {
        let inner = HTMLCollection([Text("A"), Text("B")])
        let outer = HTMLCollection([inner])
        #expect(outer.elements.count == 2)
    }

    @Test("Sequence iteration yields all elements", .publishingContext())
    func sequenceIterationYieldsAll() async throws {
        let collection = HTMLCollection([Text("A"), Text("B"), Text("C")])
        var count = 0
        for _ in collection { count += 1 }
        #expect(count == 3)
    }

    @Test("isPrimitive returns true", .publishingContext())
    func isPrimitiveReturnsTrue() async throws {
        let collection = HTMLCollection([Text("A")])
        #expect(collection.isPrimitive)
    }
}
