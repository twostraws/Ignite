//
//  String-TitleCase.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-TitleCase` extension.
@Suite("String-TitleCase Tests")
@MainActor
struct StringTitleCaseTests {
    /// Simple type meant to represent input paired with expected output
    struct Instance {
        let input: String
        let expected: String
    }

    @Test("Converts PascalCase to Title Case", arguments: [
        Instance(input: "HelloWorld", expected: "Hello World"),
        Instance(input: "ThreeWordExample", expected: "Three Word Example"),
        Instance(input: "MyApp", expected: "My App")
    ])
    func convertsPascalCaseToTitleCase(instance: Instance) async throws {
        #expect(instance.input.titleCase() == instance.expected)
    }

    @Test("Single word stays unchanged", arguments: [
        "Hello",
        "World",
        "test"
    ])
    func singleWordStaysUnchanged(word: String) async throws {
        #expect(word.titleCase() == word)
    }

    @Test("Empty string stays empty")
    func emptyStringStaysEmpty() async throws {
        #expect("".titleCase() == "")
    }

    @Test("Consecutive uppercase letters are split individually", arguments: [
        Instance(input: "XMLParser", expected: "X ML Parser"),
        Instance(input: "URLSession", expected: "U RL Session"),
        Instance(input: "HTMLElement", expected: "H TM LElement")
    ])
    func consecutiveUppercaseLettersAreSplitIndividually(instance: Instance) async throws {
        #expect(instance.input.titleCase() == instance.expected)
    }

    @Test("Handles strings with numbers", arguments: [
        Instance(input: "Section1Header", expected: "Section1 Header"),
        Instance(input: "iOS16Feature", expected: "i OS16 Feature")
    ])
    func handlesStringsWithNumbers(instance: Instance) async throws {
        #expect(instance.input.titleCase() == instance.expected)
    }

    @Test("Already-spaced strings stay unchanged", arguments: [
        "Hello World",
        "My Great App"
    ])
    func alreadySpacedStringsStayUnchanged(input: String) async throws {
        #expect(input.titleCase() == input)
    }

    @Test("Two word PascalCase", arguments: [
        Instance(input: "DarkMode", expected: "Dark Mode"),
        Instance(input: "LightTheme", expected: "Light Theme"),
        Instance(input: "HomePage", expected: "Home Page")
    ])
    func twoWordPascalCase(instance: Instance) async throws {
        #expect(instance.input.titleCase() == instance.expected)
    }
}
