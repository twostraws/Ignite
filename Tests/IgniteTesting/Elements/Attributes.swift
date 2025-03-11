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
class AttributesTest: IgniteTestSuite {
    private nonisolated static let tags: [String] = ["body", "btn", "img", "div", "nav", "section"]

    @Test("Classes are ordered", arguments: tags)
    func classes_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}.class("foo", "bar", "baz", "qux")
        let output = element.render()
        let expected = "<\(tag) class=\"foo bar baz qux\"></\(tag)>"
        #expect(output == expected)
    }

    @Test("Custom attributes are ordered", arguments: tags)
    func customAttributes_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .customAttribute(name: "qux", value: "qux")
            .customAttribute(name: "baz", value: "baz")
            .customAttribute(name: "foo", value: "foo")
            .customAttribute(name: "bar", value: "bar")

        let output = element.render()
        #expect(output == "<\(tag) qux=\"qux\" baz=\"baz\" foo=\"foo\" bar=\"bar\"></\(tag)>")
    }

    @Test("Events are ordered", arguments: tags)
    func events_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .onEvent(.mouseUp, [ShowAlert(message: "bar")])
            .onEvent(.mouseDown, [ShowAlert(message: "baz")])

        let output = element.render()

        #expect(output == """
        <\(tag) onmouseup=\"alert('bar')\" onmousedown=\"alert('baz')\"></\(tag)>
        """)
    }

    @Test("Styles are ordered", arguments: tags)
    func styles_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .style(
                .init(.zIndex, value: "1"),
                .init(.accentColor, value: "red"),
                .init(.cursor, value: "pointer")
            )
        let output = element.render()
        #expect(output == "<\(tag) style=\"z-index: 1; accent-color: red; cursor: pointer\"></\(tag)>")
    }

    @Test("Aria attributes are ordered", arguments: tags)
    func ariaAttributes_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .aria(.atomic, "bar")
            .aria(.checked, "qux")
            .aria(.setSize, "foo")

        let output = element.render()
        #expect(output == "<\(tag) aria-atomic=\"bar\" aria-checked=\"qux\" aria-setsize=\"foo\"></\(tag)>")
    }

    @Test("Data attributes are ordered", arguments: tags)
    func dataAttributes_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .data("foo", "bar")
            .data("baz", "qux")
            .data("qux", "foo")
            .data("bar", "baz")

        let output = element.render()
        #expect(output == "<\(tag) data-foo=\"bar\" data-baz=\"qux\" data-qux=\"foo\" data-bar=\"baz\"></\(tag)>")
    }

    @Test("Boolean attributes are ordered", arguments: tags)
    func booleanAttributes_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .customAttribute(.disabled)
            .customAttribute(.required)
            .customAttribute(.selected)

        let output = element.render()
        #expect(output == "<\(tag) disabled required selected></\(tag)>")
    }
}
