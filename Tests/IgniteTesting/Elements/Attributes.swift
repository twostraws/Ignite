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
    init() {
        try! PublishingContext.initialize(for: TestSite(), from: #filePath)
    }

    private nonisolated static let tags: [String] = ["body", "btn", "img", "div", "nav", "section"]

    @Test("Checks that meta highlighting tags are sorted in the head element")
    func highligtherThemes_areSorted() async throws {
        let links = MetaLink.highlighterThemeMetaLinks(for: [.xcodeDark, .githubDark, .twilight])
        let output = links.map { $0.render() }

        #expect(
            output == [
                "<link href=\"/css/prism-github-dark.css\" rel=\"stylesheet\" data-highlight-theme=\"github-dark\" />",
                "<link href=\"/css/prism-twilight.css\" rel=\"stylesheet\" data-highlight-theme=\"twilight\" />",
                "<link href=\"/css/prism-xcode-dark.css\" rel=\"stylesheet\" data-highlight-theme=\"xcode-dark\" />"
            ]
        )
    }

    @Test("Checks that classes are sorted", arguments: tags)
    func classes_areSorted(tag: String) async throws {
        let element = Tag(tag) {}.class("foo", "bar", "baz", "qux")
        let output = element.render()
        let expected = "<\(tag) class=\"bar baz foo qux\"></\(tag)>"

        #expect(
            output == expected
        )
    }

    @Test("Checks that custom attributes are sorted", arguments: Self.tags)
    func customAttributes_areSorted(tag: String) async throws {
        let element = Tag(tag) {}
            .customAttribute(name: "qux", value: "qux")
            .customAttribute(name: "baz", value: "baz")
            .customAttribute(name: "foo", value: "foo")
            .customAttribute(name: "bar", value: "bar")
        let output = element.render()

        #expect(
            output == "<\(tag) bar=\"bar\" baz=\"baz\" foo=\"foo\" qux=\"qux\"></\(tag)>"
        )
    }

    @Test("Checks that events are sorted", arguments: Self.tags)
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

    @Test("Checks that styles are sorted", arguments: Self.tags)
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

    @Test("Checks that aria attributes are sorted", arguments: Self.tags)
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

    @Test("Checks that data attributes are sorted", arguments: Self.tags)
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

    @Test("Checks that boolean attributes are sorted", arguments: Self.tags)
    func test_boolean_attributes_are_sorted(tag: String) async throws {
        let element = Tag(tag) {}
            .disabled()
            .required()
            .booleanAttribute("foo")
            .booleanAttribute("qux")
            .booleanAttribute("bar")
            .booleanAttribute("baz")
        let output = element.render(context: publishingContext)

        #expect(
            output == "<\(tag) bar baz disabled foo qux required></\(tag)>"
        )
    }

    @Test("Checks that disabled attributes are not included in the output", arguments: Self.tags)
    func test_disabled_attributes_are_not_included_in_the_output(tag: String) async throws {
        let element = Tag(tag) {}
            .disabled(false)
            .required(false)
            .booleanAttribute("foo", isEnabled: false)
            .booleanAttribute("qux", isEnabled: false)
            .booleanAttribute("bar", isEnabled: false)
            .booleanAttribute("baz", isEnabled: false)
        let output = element.render(context: publishingContext)

        #expect(
            output == "<\(tag)></\(tag)>"
        )
    }
}
