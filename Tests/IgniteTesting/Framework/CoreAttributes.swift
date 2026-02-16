//
//  CoreAttributes.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `CoreAttributes` type.
@Suite("CoreAttributes Tests")
@MainActor
struct CoreAttributesTests {
    // MARK: - isEmpty

    @Test("Default instance is empty")
    func defaultIsEmpty() async throws {
        let attrs = CoreAttributes()
        #expect(attrs.isEmpty)
    }

    @Test("Instance with id is not empty")
    func withIdIsNotEmpty() async throws {
        var attrs = CoreAttributes()
        attrs.id = "test"
        #expect(!attrs.isEmpty)
    }

    // MARK: - Classes

    @Test("Append variadic classes")
    func appendVariadicClasses() async throws {
        var attrs = CoreAttributes()
        attrs.append(classes: "foo", "bar", "baz")
        #expect(attrs.classes.count == 3)
        #expect(attrs.classString == " class=\"foo bar baz\"")
    }

    @Test("Append nil classes are filtered out")
    func appendNilClassesAreFiltered() async throws {
        var attrs = CoreAttributes()
        let nilClass: String? = nil
        attrs.append(classes: "foo", nilClass, "bar")
        #expect(attrs.classes.count == 2)
    }

    @Test("Append collection of classes")
    func appendCollectionClasses() async throws {
        var attrs = CoreAttributes()
        attrs.append(classes: ["alpha", "beta"])
        #expect(attrs.classes.count == 2)
    }

    @Test("Remove classes")
    func removeClasses() async throws {
        var attrs = CoreAttributes()
        attrs.append(classes: "foo", "bar", "baz")
        attrs.remove(classes: "bar")
        #expect(attrs.classes.count == 2)
        #expect(!attrs.classes.contains("bar"))
    }

    @Test("Appending classes returns new copy without mutating original")
    func appendingClassesReturnsNewCopy() async throws {
        var original = CoreAttributes()
        original.append(classes: "foo")
        let copy = original.appending(classes: ["bar"])
        #expect(original.classes.count == 1)
        #expect(copy.classes.count == 2)
    }

    // MARK: - Styles

    @Test("Append styles filters empty values")
    func appendStylesFiltersEmpty() async throws {
        var attrs = CoreAttributes()
        attrs.append(styles: InlineStyle(.color, value: "red"), InlineStyle(.padding, value: ""))
        #expect(attrs.styles.count == 1)
    }

    @Test("Append style with empty value is no-op")
    func appendStyleEmptyValueNoOp() async throws {
        var attrs = CoreAttributes()
        attrs.append(style: .color, value: "")
        #expect(attrs.styles.isEmpty)
    }

    @Test("Remove styles by property")
    func removeStylesByProperty() async throws {
        var attrs = CoreAttributes()
        attrs.append(styles: InlineStyle(.color, value: "red"), InlineStyle(.padding, value: "10px"))
        attrs.remove(styles: .color)
        #expect(attrs.styles.count == 1)
        #expect(attrs.styleString.contains("padding"))
        #expect(!attrs.styleString.contains("color"))
    }

    @Test("Append style collection filters empty values")
    func appendStyleCollectionFiltersEmpty() async throws {
        var attrs = CoreAttributes()
        attrs.append(styles: [
            InlineStyle(.color, value: "red"),
            InlineStyle(.padding, value: "")
        ])
        #expect(attrs.styles.count == 1)
    }

    // MARK: - Get styles

    @Test("Get styles returns matching properties")
    func getStylesReturnsMatching() async throws {
        var attrs = CoreAttributes()
        attrs.append(styles: InlineStyle(.color, value: "blue"), InlineStyle(.padding, value: "5px"))
        let found = attrs.get(styles: .color)
        #expect(found.count == 1)
        #expect(found.first?.value == "blue")
    }

    @Test("Get styles returns empty for non-matching")
    func getStylesReturnsEmptyForNonMatching() async throws {
        var attrs = CoreAttributes()
        attrs.append(styles: InlineStyle(.color, value: "red"))
        let found = attrs.get(styles: .padding)
        #expect(found.isEmpty)
    }

    // MARK: - Clear

    @Test("Clear resets to empty")
    func clearResetsToEmpty() async throws {
        var attrs = CoreAttributes()
        attrs.id = "test"
        attrs.append(classes: "foo")
        attrs.append(styles: InlineStyle(.color, value: "red"))
        attrs.clear()
        #expect(attrs.isEmpty)
    }

    // MARK: - Merge

    @Test("Merge combines classes and styles from both instances")
    func mergeCombinesClassesAndStyles() async throws {
        var a = CoreAttributes()
        a.append(classes: "foo")
        a.append(styles: InlineStyle(.color, value: "red"))

        var b = CoreAttributes()
        b.append(classes: "bar")
        b.append(styles: InlineStyle(.padding, value: "10px"))

        a.merge(b)
        #expect(a.classes.count == 2)
        #expect(a.styles.count == 2)
    }

    @Test("Merge overwrites id when other is non-empty")
    func mergeOverwritesId() async throws {
        var a = CoreAttributes()
        a.id = "original"

        var b = CoreAttributes()
        b.id = "replacement"

        a.merge(b)
        #expect(a.id == "replacement")
    }

    @Test("Merge preserves id when other id is empty")
    func mergePreservesId() async throws {
        var a = CoreAttributes()
        a.id = "original"

        let b = CoreAttributes()
        a.merge(b)
        #expect(a.id == "original")
    }

    @Test("Merging returns new combined instance without mutating original")
    func mergingReturnsNewCombined() async throws {
        var a = CoreAttributes()
        a.append(classes: "foo")

        var b = CoreAttributes()
        b.append(classes: "bar")

        let result = a.merging(b)
        #expect(result.classes.count == 2)
        #expect(a.classes.count == 1)
    }

    // MARK: - Custom attributes and data

    @Test("Remove custom attributes by name")
    func removeCustomAttributesByName() async throws {
        var attrs = CoreAttributes()
        attrs.append(customAttributes: Attribute(name: "loading", value: "lazy"))
        attrs.remove(attributesNamed: "loading")
        #expect(attrs.customAttributes.isEmpty)
    }

    @Test("Appending nil aria is no-op")
    func appendingNilAriaIsNoOp() async throws {
        let attrs = CoreAttributes()
        let result = attrs.appending(aria: nil)
        #expect(result == attrs)
    }

    // MARK: - String computed properties

    @Test("idString format with non-empty id")
    func idStringFormat() async throws {
        var attrs = CoreAttributes()
        attrs.id = "main"
        #expect(attrs.idString == " id=\"main\"")
    }

    @Test("Empty id produces empty idString")
    func emptyIdProducesEmptyIdString() async throws {
        let attrs = CoreAttributes()
        #expect(attrs.idString == "")
    }

    @Test("styleString format")
    func styleStringFormat() async throws {
        var attrs = CoreAttributes()
        attrs.append(styles: InlineStyle(.color, value: "red"))
        #expect(attrs.styleString == " style=\"color: red\"")
    }

    @Test("Description combines all attribute components")
    func descriptionCombinesAll() async throws {
        var attrs = CoreAttributes()
        attrs.id = "test"
        attrs.append(classes: "foo")
        attrs.append(styles: InlineStyle(.color, value: "red"))
        let desc = attrs.description
        #expect(desc.contains("id=\"test\""))
        #expect(desc.contains("class=\"foo\""))
        #expect(desc.contains("style=\"color: red\""))
    }
}
