//
//  Test.swift
//  Ignite
//
//  Created by Dorian on 13/01/2025.
//

import Testing
import Ignite

/// Tests for the element's `Attributes`.
@Suite("Attributes Tests")
@MainActor
struct AttributesTest {
    let publishingContext = ElementTest.publishingContext

    private nonisolated static let tags: [String] = ["body", "btn", "img", "div", "nav", "section"]


    @Test("Checks that classes are sorted", arguments: tags)
    func test_classes_are_sorted(tag: String) async throws {
        let element = Tag(tag) {}.class("foo", "bar", "baz", "qux")
        let output = element.render(context: publishingContext)
        let expected = "<\(tag) class=\"bar baz foo qux\"></\(tag)>"

        #expect(
            output == expected
        )
    }

    @Test("Checks that custom attributes are sorted", arguments: Self.tags)
    func test_custom_attributes_are_sorted(tag: String) async throws {
        let element = Tag(tag) {}
            .customAttribute(name: "qux", value: "qux")
            .customAttribute(name: "baz", value: "baz")
            .customAttribute(name: "foo", value: "foo")
            .customAttribute(name: "bar", value: "bar")
        let output = element.render(context: publishingContext)

        #expect(
            output == "<\(tag) bar=\"bar\" baz=\"baz\" foo=\"foo\" qux=\"qux\"></\(tag)>"
        )
    }

    @Test("Checks that events are sorted", arguments: Self.tags)
    func test_events_are_sorted(tag: String) async throws {
        let element = Tag(tag) {}
            .addEvent(name: "bar", actions: [ShowAlert(message: "bar")])
            .addEvent(name: "baz", actions: [ShowAlert(message: "baz")])
            .addEvent(name: "qux", actions: [ShowAlert(message: "qux")])
            .addEvent(name: "foo", actions: [ShowAlert(message: "foo")])
        let output = element.render(context: publishingContext)

        #expect(
            output == "<\(tag) bar=\"alert('bar')\" baz=\"alert('baz')\" foo=\"alert('foo')\" qux=\"alert('qux')\"></\(tag)>"
        )
    }
}
