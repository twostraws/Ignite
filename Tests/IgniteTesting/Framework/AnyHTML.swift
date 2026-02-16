//
//  AnyHTML.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `AnyHTML` type-erasing wrapper.
@Suite("AnyHTML Tests")
@MainActor
struct AnyHTMLTests {
    @Test("Unwraps nested AnyHTML to prevent double-wrapping")
    func unwrapsNestedAnyHTML() async throws {
        let inner = AnyHTML(Text("Hello"))
        let outer = AnyHTML(inner)
        #expect(!(outer.wrapped is AnyHTML))
    }

    @Test("Merges attributes from wrapped content")
    func mergesAttributesFromWrapped() async throws {
        var text = Text("Hello")
        text.attributes.append(classes: "custom")
        let any = AnyHTML(text)
        #expect(any.attributes.classes.contains("custom"))
    }

    @Test("Clears attributes on wrapped content after merging")
    func clearsWrappedAttributes() async throws {
        var text = Text("Hello")
        text.attributes.append(classes: "custom")
        let any = AnyHTML(text)
        #expect(any.wrapped.attributes.classes.isEmpty)
    }

    @Test("isPrimitive returns true")
    func isPrimitiveReturnsTrue() async throws {
        let any = AnyHTML(Text("Hello"))
        #expect(any.isPrimitive)
    }
}
