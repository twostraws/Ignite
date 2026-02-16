//
//  HighlighterLanguage.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for `HighlighterLanguage`.
@Suite("HighlighterLanguage Tests")
@MainActor
struct HighlighterLanguageTests {
    @Test("Languages with dependencies expose the expected dependency graph", arguments: [
        (language: HighlighterLanguage.c, expectedDependency: HighlighterLanguage?.some(.cLike)),
        (language: HighlighterLanguage.cPlusPlus, expectedDependency: HighlighterLanguage?.some(.c)),
        (language: HighlighterLanguage.markdown, expectedDependency: HighlighterLanguage?.some(.markup)),
        (language: HighlighterLanguage.typeScript, expectedDependency: HighlighterLanguage?.some(.javaScript)),
        (language: HighlighterLanguage.swift, expectedDependency: HighlighterLanguage?.none)
    ])
    func dependencies(language: HighlighterLanguage, expectedDependency: HighlighterLanguage?) async throws {
        #expect(language.dependency == expectedDependency)
    }

    @Test("Files include core, dependency, then language file when dependency exists")
    func filesIncludeDependencyInOrder() async throws {
        let files = HighlighterLanguage.typeScript.files
        #expect(files == ["prism-core.js", "javascript.js", "typescript.js"])
    }

    @Test("Files include only core and language file when no dependency exists")
    func filesWithoutDependency() async throws {
        let files = HighlighterLanguage.swift.files
        #expect(files == ["prism-core.js", "swift.js"])
    }

    @Test("Alias raw values map to Prism filenames")
    func aliasRawValuesMapCorrectly() async throws {
        #expect(HighlighterLanguage.markup.rawValue == "xml")
        #expect(HighlighterLanguage.webAssembly.rawValue == "wasm")
        #expect(HighlighterLanguage.cPlusPlus.rawValue == "cpp")
    }
}
