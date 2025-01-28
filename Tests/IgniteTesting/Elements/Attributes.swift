//
//  Attributes.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

@testable import Ignite
import Testing

/// Tests for the element's `Attributes`.
@Suite("Attributes Tests")
@MainActor
struct AttributesTest {
    init() throws {
        try PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    private nonisolated static let tags: [String] = ["body", "btn", "img", "div", "nav", "section"]

    @Test("Classes are sorted", arguments: tags)
    func classes_areSorted(tag: String) async throws {
        let element = Tag(tag) {}.class("foo", "bar", "baz", "qux")
        let output = element.render()
        let expected = "<\(tag) class=\"bar baz foo qux\"></\(tag)>"

        #expect(output == expected)
    }

    @Test("Custom attributes are sorted", arguments: tags)
    func customAttributes_areSorted(tag: String) async throws {
        let element = Tag(tag) {}
            .customAttribute(name: "qux", value: "qux")
            .customAttribute(name: "baz", value: "baz")
            .customAttribute(name: "foo", value: "foo")
            .customAttribute(name: "bar", value: "bar")
        let output = element.render()

        #expect(output == "<\(tag) bar=\"bar\" baz=\"baz\" foo=\"foo\" qux=\"qux\"></\(tag)>")
    }

    @Test("Events are sorted", arguments: tags)
    func events_areSorted(tag: String) async throws {
        let element = Tag(tag) {}
            .addEvent(name: "bar", actions: [ShowAlert(message: "bar")])
            .addEvent(name: "baz", actions: [ShowAlert(message: "baz")])
            .addEvent(name: "qux", actions: [ShowAlert(message: "qux")])
            .addEvent(name: "foo", actions: [ShowAlert(message: "foo")])
        let output = element.render()

        #expect(
            output == """
            <\(tag) bar=\"alert('bar')\" baz=\"alert('baz')\" foo=\"alert('foo')\" qux=\"alert('qux')\"></\(tag)>
            """
        )
    }

    @Test("Styles are sorted", arguments: tags)
    func styles_areSorted(tag: String) async throws {
        let element = Tag(tag) {}
            .style(
                .init(.zIndex, value: "1"),
                .init(.accentColor, value: "red"),
                .init(.cursor, value: "pointer")
            )
        let output = element.render()

        #expect(
            output == "<\(tag) style=\"accent-color: red; cursor: pointer; z-index: 1\"></\(tag)>"
        )
    }

    @Test("Aria attributes are sorted", arguments: tags)
    func ariaAttributes_areSorted(tag: String) async throws {
        let element = Tag(tag) {}
            .aria(.atomic, "bar")
            .aria(.checked, "qux")
            .aria(.setSize, "foo")
        let output = element.render()

        #expect(
            output == "<\(tag) aria-atomic=\"bar\" aria-checked=\"qux\" aria-setsize=\"foo\"></\(tag)>"
        )
    }

    @Test("Data attributes are sorted", arguments: tags)
    func dataAttributes_areSorted(tag: String) async throws {
        let element = Tag(tag) {}
            .data("foo", "bar")
            .data("baz", "qux")
            .data("qux", "foo")
            .data("bar", "baz")
        let output = element.render()

        #expect(
            output == "<\(tag) data-bar=\"baz\" data-baz=\"qux\" data-foo=\"bar\" data-qux=\"foo\"></\(tag)>"
        )
    }

    @Test("Boolean attributes are sorted", arguments: tags)
    func booleanAttributes_areSorted(tag: String) async throws {
        let element = Tag(tag) {}
            .customAttribute(.disabled)
            .customAttribute(.required)
            .customAttribute(.selected)
        let output = element.render()

        #expect(output == "<\(tag) disabled required selected></\(tag)>")
    }
}
