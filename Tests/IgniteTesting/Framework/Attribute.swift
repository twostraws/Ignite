//
//  Attribute.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `Attribute` type and its convenience extensions.
@Suite("Attribute Tests")
@MainActor
struct AttributeTests {
    // MARK: - Description

    @Test("Name-value attribute description includes quotes")
    func nameValueDescription() async throws {
        let attr = Attribute(name: "target", value: "_blank")
        #expect(attr.description == "target=\"_blank\"")
    }

    @Test("Boolean attribute description is just the name")
    func booleanDescription() async throws {
        let attr = Attribute("disabled")
        #expect(attr.description == "disabled")
        #expect(attr.value == nil)
    }

    // MARK: - Comparable

    @Test("Attributes are ordered by description")
    func comparableByDescription() async throws {
        let a = Attribute(name: "alpha", value: "1")
        let b = Attribute(name: "beta", value: "2")
        #expect(a < b)
    }

    // MARK: - Equatable

    @Test("Same name and value are equal")
    func sameNameValueAreEqual() async throws {
        let a = Attribute(name: "rel", value: "stylesheet")
        let b = Attribute(name: "rel", value: "stylesheet")
        #expect(a == b)
    }

    @Test("Different values are not equal")
    func differentValuesAreNotEqual() async throws {
        let a = Attribute(name: "rel", value: "stylesheet")
        let b = Attribute(name: "rel", value: "nofollow")
        #expect(a != b)
    }

    // MARK: - Convenience boolean attributes

    @Test("Convenience boolean attributes have correct names", arguments: [
        (Attribute.disabled, "disabled"),
        (.required, "required"),
        (.readOnly, "readonly"),
        (.checked, "checked"),
        (.selected, "selected"),
        (.controls, "controls")
    ])
    func convenienceBooleanAttributes(attribute: Attribute, expectedName: String) async throws {
        #expect(attribute.name == expectedName)
        #expect(attribute.value == nil)
    }

    // MARK: - HiddenState

    @Test("HiddenState untilFound raw value uses kebab-case")
    func hiddenStateUntilFoundRawValue() async throws {
        #expect(Attribute.HiddenState.untilFound.rawValue == "until-found")
    }

    @Test("Hidden factory method produces correct attribute")
    func hiddenFactoryMethod() async throws {
        let attr = Attribute.hidden(.true)
        #expect(attr.name == "hidden")
        #expect(attr.value == "true")

        let untilFound = Attribute.hidden(.untilFound)
        #expect(untilFound.value == "until-found")
    }
}
