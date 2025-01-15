//
//  Attributes.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing
import Ignite

/// Tests for the element's `Attributes`.
@Suite("Attributes Tests")
@MainActor
struct AttributesTest {
    let publishingContext = ElementTest.publishingContext

    private nonisolated static let tags: [String] = ["body", "btn", "img", "div", "nav", "section"]

    @Test("Checks that meta highlighting tags are sorted in the head element")
    func test_highligther_themes_are_sorted() async throws {
        let links = MetaLink.highlighterThemeMetaLinks(for: [.xcodeDark, .githubDark, .githubLight])
        let output = links.map { $0.render(context:  publishingContext )}

        #expect(
            output == [
                "<link disabled=\"\" href=\"/css/prism-github-dark.css\" rel=\"stylesheet\" data-highlight-theme=\"github-dark\" />",
                "<link disabled=\"\" href=\"/css/prism-github-light.css\" rel=\"stylesheet\" data-highlight-theme=\"github-light\" />",
                "<link disabled=\"\" href=\"/css/prism-xcode-dark.css\" rel=\"stylesheet\" data-highlight-theme=\"xcode-dark\" />"
            ]
        )
    }

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

    @Test("Checks that styles are sorted", arguments: Self.tags)
    func test_styles_are_sorted(tag: String) async throws {
        let element = Tag(tag) {}
            .style("foo: bar", "bar: baz", "baz: qux", "qux: foo")
        let output = element.render(context: publishingContext)

        #expect(
            output == "<\(tag) style=\"bar: baz; baz: qux; foo: bar; qux: foo\"></\(tag)>"
        )
    }

    @Test("Checks that aria attributes are sorted", arguments: Self.tags)
    func test_aria_attributes_are_sorted(tag: String) async throws {
        let element = Tag(tag) {}
            .aria("foo", "bar")
            .aria("baz", "qux")
            .aria("qux", "foo")
            .aria("bar", "baz")
        let output = element.render(context: publishingContext)

        #expect(
            output == "<\(tag) aria-bar=\"baz\" aria-baz=\"qux\" aria-foo=\"bar\" aria-qux=\"foo\"></\(tag)>"
        )
    }

    @Test("Checks that data attributes are sorted", arguments: Self.tags)
    func test_data_attributes_are_sorted(tag: String) async throws {
        let element = Tag(tag) {}
            .data("foo", "bar")
            .data("baz", "qux")
            .data("qux", "foo")
            .data("bar", "baz")
        let output = element.render(context: publishingContext)

        #expect(
            output == "<\(tag) data-bar=\"baz\" data-baz=\"qux\" data-foo=\"bar\" data-qux=\"foo\"></\(tag)>"
        )
    }
}
