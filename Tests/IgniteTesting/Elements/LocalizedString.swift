//
// LocalizedString.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for rendering `LocalizedString` values.
@Suite("LocalizedString Tests")
class LocalizedStringTests: IgniteTestSuite {
    /// Switches the current publishing context to a Spanish site whose strings
    /// come from the test target's `Localizable.xcstrings`.
    private func useSpanishSite() {
        let site = LocalizedTestSite()

        let context = PublishingContext.shared
        context.site = site
        context.environment = EnvironmentValues(
            sourceDirectory: URL(filePath: ""),
            site: site,
            allContent: []
        )
    }

    @Test("Literal without a catalog entry renders unchanged", .publishingContext())
    func literalWithoutEntry() async throws {
        let element = Text("Hello")
        let output = element.markupString()

        #expect(output == "<p>Hello</p>")
    }

    @Test("Literal resolves using the site language and catalog", .publishingContext())
    func literalResolvesInSiteLanguage() async throws {
        useSpanishSite()

        let element = Text("Welcome")
        let output = element.markupString()

        #expect(output == "<p>Bienvenido</p>")
    }

    @Test("Interpolated literal resolves using the site language", .publishingContext())
    func interpolatedLiteral() async throws {
        useSpanishSite()

        let name = "Ana"
        let element = Text("Hello \(name)")
        let output = element.markupString()

        #expect(output == "<p>Hola Ana</p>")
    }

    @Test("Localized string works anywhere an inline element is accepted", .publishingContext())
    func localizedStringInInlineElement() async throws {
        useSpanishSite()

        let output = Span("Welcome" as LocalizedString).markupString()

        #expect(output == "<span>Bienvenido</span>")
    }

    @Test("Positional arguments can be reordered by translations", .publishingContext())
    func positionalArguments() async throws {
        let first = "A"
        let second = "B"
        let string: LocalizedString = "Pair \(first) \(second)"
        let output = string.substitutingArguments(into: "%2$@ then %1$@ 100%%")

        #expect(output == "B then A 100%")
    }

    @Test("String variables are not localized", .publishingContext())
    func stringVariableIsVerbatim() async throws {
        useSpanishSite()

        let value = "Welcome"
        let output = Text(value).markupString()

        #expect(output == "<p>Welcome</p>")
    }
}

private struct LocalizedTestSite: Site {
    var name = "My Localized Site"
    var url = URL(static: "https://www.example.com")
    var language: Language = .spanish
    var localizationCatalog: URL? {
        Bundle.module.url(forResource: "Localizable", withExtension: "xcstrings", subdirectory: "Localization")
    }

    var homePage = TestPage()
    var layout = EmptyLayout()
}

/// Tests for reading string catalogs.
@Suite("StringCatalog Tests")
struct StringCatalogTests {
    private let catalog = StringCatalog(
        sourceLanguage: "en",
        strings: [
            "Welcome": .init(localizations: [
                "en": .init(stringUnit: .init(value: "Welcome!")),
                "pt": .init(stringUnit: .init(value: "Bem-vindo")),
                "pt-BR": .init(stringUnit: .init(value: "Bem-vindo, brasileiro")),
            ]),
            "Goodbye": .init(localizations: [
                "en": .init(stringUnit: .init(value: "Goodbye!")),
            ]),
        ]
    )

    @Test("Full language identifier is preferred")
    func fullIdentifier() {
        #expect(catalog.localizedString(for: "Welcome", language: "pt-BR") == "Bem-vindo, brasileiro")
    }

    @Test("Region falls back to the language code")
    func languageCodeFallback() {
        #expect(catalog.localizedString(for: "Welcome", language: "pt-PT") == "Bem-vindo")
    }

    @Test("Missing language falls back to the source language")
    func sourceLanguageFallback() {
        #expect(catalog.localizedString(for: "Goodbye", language: "es") == "Goodbye!")
    }

    @Test("Missing key returns the key")
    func missingKey() {
        #expect(catalog.localizedString(for: "Unknown", language: "es") == "Unknown")
    }
}
