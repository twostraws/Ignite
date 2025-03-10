//
//  String-Slug.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-Slug` extension.
@Suite("String-Slug Tests")
@MainActor
struct StringSlugTests {
    /// Some types of string will have an output that's the same as their input.
    /// Test examples of each of those cases
    @Test("Noop Cases", arguments: [
        "a", // single character
        "1", // single digit
        "one", // single word
        "15-3", // subtraction math expression
        "hello-world", // kebab-cased
        "hello-wonderful-world"
    ])
    func does_not_change_simple_cases(string: String) async throws {
        #expect(string.convertedToSlug() == string)
    }

    @Test("Converts Title-Cased Single Words To Lowercase", arguments: [
        "A",
        "Cars",
        "Hollywood"
    ])
    func converts_title_case_to_lowercase(string: String) async throws {
        #expect(string.convertedToSlug() == string.lowercased())
    }

    struct Instance {
        let input: String
        let expected: String
    }

    @Test("Transliterates Non-latin Scripts", arguments: [
        // I've tried to use non-controversial words here:
        // "peace" in three of the scripts
        // and "oolong tea" in the other two.
        // these were also just very easy-to-find words online
        // as I don't speak any of these languages.
        // No stereotyping or cultural judgment is intended
        Instance(input: "мир", expected: "mir"),
        Instance(input: "烏龍茶", expected: "wu-long-cha"),
        Instance(input: "ウーロン茶", expected: "uron-cha"),
        Instance(input: "שָׁלוֹם", expected: "salwom"),
        Instance(input: "שָׁלוֹםسلام", expected: "salwomslam"),
        Instance(input: "мир" + "שָׁלוֹםسلام" + "שָׁלוֹם" + "烏龍茶" + "ウーロン茶",
                 expected: "mirsalwomslamsalwom-wu-long-chauron-cha")
    ])
    func transliterates_characters_in_non_latin_scripts(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Strips Diacritivs", arguments: [
        Instance(input: "días", expected: "dias"),
        Instance(input: "baño", expected: "bano"),
        Instance(input: "çest", expected: "cest"),
        Instance(input: "Straße", expected: "strasse")
    ])
    func strips_diacritics(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Strips Leading and Trailing Punctuation", arguments: [
        Instance(input: "up!", expected: "up"),
        Instance(input: "c.", expected: "c"),
        Instance(input: "15!", expected: "15"),
        Instance(input: ".lowercase", expected: "lowercase")
    ])
    func strips_punctuation_from_ends_of_string(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Replaces Punctuation between words with dash", arguments: [
        Instance(input: "y.m.c.a.", expected: "y-m-c-a"),
        Instance(input: "here, there and everywhere", expected: "here-there-and-everywhere"),
        Instance(input: "this, that, and the other thing", expected: "this-that-and-the-other-thing"),
        Instance(input: "planes, trains & automobiles", expected: "planes-trains-automobiles")
    ])
    func removes_punctuation_between_words(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Removes emoji leaving other words", arguments: [
        Instance(input: "😄smiley", expected: "smiley"),
        Instance(input: "smiley😄", expected: "smiley"),
        Instance(input: "this😄and😄that😄", expected: "this-and-that")
    ])
    func removes_emoji_between_words(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Replaces Capitalized Characters with Dash then Lowercase", arguments: [
        Instance(input: "CARS", expected: "c-a-r-s"),
        Instance(input: "HELLO", expected: "h-e-l-l-o"),
        Instance(input: "FBI", expected: "f-b-i")
    ])
    func replaces_capitalized_characters_with_dash_then_lowercase(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Replaces Common Math Operators with Dashes", arguments: [
        Instance(input: "15+3", expected: "15-3"),
        Instance(input: "15-3=12", expected: "15-3-12"), // math expressions expected: ""),
        Instance(input: "15+3=18", expected: "15-3-18"),
        Instance(input: "15÷3=5", expected: "15-3-5"),
        Instance(input: "15/3=5", expected: "15-3-5"),
        Instance(input: "15 / 3 = 5", expected: "15-3-5")
    ])
    func replaces_common_math_operators_with_dash(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Leaves Existing Dashes when converting to lowercase", arguments: [
        Instance(input: "Hello-world", expected: "hello-world"),
        Instance(input: "Happy-go-lucky", expected: "happy-go-lucky")
    ])
    func respects_existing_dashes_when_converting_to_lowercase(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Replaces Underscaore with Dashes", arguments: [
        Instance(input: "hello_world", expected: "hello-world"),
        Instance(input: "hello_happy_world", expected: "hello-happy-world")
    ])
    func reaplces_underscores_with_dashes(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Concatenates Lowercase Words With Dashes", arguments: [
        "a b",
        "one two",
        "buckle my shoe"
    ])
    func concatenates_lowercase_words_with_dashes(string: String) async throws {
        #expect(string.convertedToSlug() == string.replacingOccurrences(of: " ", with: "-"))
    }

    //    in the case where there's a dash followed by an uppercase letter
    //    a second dash is inserted and the uppercase letter is converted to lowercase.
    //    which results in two dashes in a row
    @Test("Replaces dash before uppercase letter with two dashes before lowercase letter", arguments: [
        Instance(input: "hello-World", expected: "hello-world"),
        Instance(input: "Hello-World", expected: "hello-world"),
        Instance(input: "Happy-Go-Lucky", expected: "happy-go-lucky")
    ])
    func double_dash_for_dash_then_uppercase(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Replaces All Whitespace Between Lowercase Words With Dashes", arguments: [
        Instance(input: "a\tb", expected: "a-b"),
        Instance(input: "one\ntwo", expected: "one-two"),
        Instance(input: "one\r\ntwo", expected: "one-two"),
        Instance(input: "buckle\nmy\tshoe", expected: "buckle-my-shoe"),
        Instance(input: "buckle\n\n\nmy\t\t\tshoe", expected: "buckle-my-shoe")
    ])
    func concatenatesa_lowercase_words_with_dashes(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Acronyms are lowercased and double-dash-separated", arguments: [
        Instance(input: "Y.M.C.A.", expected: "y-m-c-a"),
        Instance(input: "F.B.I.", expected: "f-b-i")
    ])
    func acronyms_are_lowercased_and_dash_separated(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Converts camelCase to dash-case", arguments: [
        Instance(input: "camelCase", expected: "camel-case"),
        Instance(input: "threeWordExample", expected: "three-word-example"),
        Instance(input: "aLongerExampleWithSixWords", expected: "a-longer-example-with-six-words")
    ])
    func converts_camelCase_to_dash_case(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("URL Strings", arguments: [
        Instance(input: "https://github.com/twostraws/Ignite", expected: "https-github-com-twostraws-ignite"),
        Instance(input: "https://github.com/twostraws/Ignite/", expected: "https-github-com-twostraws-ignite"),
        Instance(input: "file:/Users/george/Documents", expected: "file-users-george-documents")
    ])
    func url_strings(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

    @Test("Paths", arguments: [
        Instance(input: "/Users/george/Documents", expected: "-users-george-documents"),
        Instance(input: "/twostraws/Ignite", expected: "twostraws-ignite"),
        Instance(input: "~/Documents", expected: "-documents"),
        Instance(input: "~/Documents/Resumé", expected: "-documents-resume")
    ])
    func path_strings(instance: Instance) async throws {
        #expect(instance.input.convertedToSlug() == instance.expected)
    }

}
