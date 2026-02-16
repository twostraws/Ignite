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
        let output = element.markupString()
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

        let output = element.markupString()
        #expect(output == "<\(tag) qux=\"qux\" baz=\"baz\" foo=\"foo\" bar=\"bar\"></\(tag)>")
    }

    @Test("Events are ordered", arguments: tags)
    func events_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .onEvent(.mouseUp, [ShowAlert(message: "bar")])
            .onEvent(.mouseDown, [ShowAlert(message: "baz")])

        let output = element.markupString()

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
        let output = element.markupString()
        #expect(output == "<\(tag) style=\"z-index: 1; accent-color: red; cursor: pointer\"></\(tag)>")
    }

    @Test("Aria attributes are ordered", arguments: tags)
    func ariaAttributes_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .aria(.atomic, "bar")
            .aria(.checked, "qux")
            .aria(.setSize, "foo")

        let output = element.markupString()
        #expect(output == "<\(tag) aria-atomic=\"bar\" aria-checked=\"qux\" aria-setsize=\"foo\"></\(tag)>")
    }

    @Test("Data attributes are ordered", arguments: tags)
    func dataAttributes_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .data("foo", "bar")
            .data("baz", "qux")
            .data("qux", "foo")
            .data("bar", "baz")

        let output = element.markupString()
        #expect(output == "<\(tag) data-foo=\"bar\" data-baz=\"qux\" data-qux=\"foo\" data-bar=\"baz\"></\(tag)>")
    }

    @Test("Boolean attributes are ordered", arguments: tags)
    func booleanAttributes_areOrdered(tag: String) async throws {
        let element = Tag(tag) {}
            .customAttribute(.disabled)
            .customAttribute(.required)
            .customAttribute(.selected)

        let output = element.markupString()
        #expect(output == "<\(tag) disabled required selected></\(tag)>")
    }

    // MARK: - ID modifier

    @Test("ID modifier produces id attribute on HTML element", arguments: tags)
    func idModifierOnHTML(tag: String) async throws {
        let element = Tag(tag) {}.id("my-element")
        let output = element.markupString()
        #expect(output == "<\(tag) id=\"my-element\"></\(tag)>")
    }

    @Test("ID modifier produces id attribute on inline element")
    func idModifierOnInlineElement() async throws {
        let element = Emphasis("Hello").id("em-1")
        let output = element.markupString()
        #expect(output.contains("id=\"em-1\""))
        #expect(output.contains("<em"))
    }

    @Test("Empty ID is a no-op", arguments: tags)
    func emptyIDIsNoOp(tag: String) async throws {
        let element = Tag(tag) {}.id("")
        let output = element.markupString()
        #expect(output == "<\(tag)></\(tag)>")
    }

    // MARK: - Inline style modifier (public Property API)

    @Test("Public style modifier with Property adds inline style", arguments: tags)
    func publicStyleModifierAddsInlineStyle(tag: String) async throws {
        let element = Tag(tag) {}.style(.color, "red")
        let output = element.markupString()
        #expect(output == "<\(tag) style=\"color: red\"></\(tag)>")
    }

    @Test("Style modifier on inline element")
    func styleModifierOnInlineElement() async throws {
        let element = Emphasis("Bold").style(.color, "blue")
        let output = element.markupString()
        #expect(output.contains("style=\"color: blue\""))
    }

    // MARK: - CoreAttributes modifier

    @Test("CoreAttributes modifier merges classes and styles")
    func coreAttributesModifierMergesAttributes() async throws {
        var attrs = CoreAttributes()
        attrs.append(classes: "custom-class")
        attrs.append(styles: InlineStyle(.color, value: "green"))

        let element = Text("Hello").attributes(attrs)
        let output = element.markupString()
        #expect(output.contains("custom-class"))
        #expect(output.contains("color: green"))
    }

    // MARK: - InlineElement paths

    @Test("Aria modifier on inline element")
    func ariaOnInlineElement() async throws {
        let element = Emphasis("Hello").aria(.label, "greeting")
        let output = element.markupString()
        #expect(output.contains("aria-label=\"greeting\""))
    }

    @Test("Class modifier on inline element")
    func classOnInlineElement() async throws {
        let element = Emphasis("Hello").class("highlight")
        let output = element.markupString()
        #expect(output.contains("class=\"highlight\""))
    }

    @Test("Data modifier on inline element")
    func dataOnInlineElement() async throws {
        let element = Emphasis("Hello").data("info", "test")
        let output = element.markupString()
        #expect(output.contains("data-info=\"test\""))
    }

    @Test("Empty data value is a no-op")
    func emptyDataValueIsNoOp() async throws {
        let element = Tag("div") {}.data("key", "")
        let output = element.markupString()
        #expect(!output.contains("data-key"))
    }

    @Test("Optional nil aria value is a no-op")
    func optionalNilAriaIsNoOp() async throws {
        let value: String? = nil
        let element = Tag("div") {}.aria(.label, value)
        let output = element.markupString()
        #expect(!output.contains("aria-label"))
    }
}
