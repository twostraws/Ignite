//
//  String-StrippingTags.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-StrippingTags` extension.
@Suite("String-StrippingTags Tests")
@MainActor
struct StringStrippingTagsTests {
    @Test("When string contains one HTML tag")
    func strippingTags_fromStringWithOneHTMLTag() async throws {
        // Given
        let input = "<p>Hello, Swift developer!</p>"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "Hello, Swift developer!")
    }

    @Test("When string contains multiple HTML tags")
    func strippingTags_fromStringWithMultipleTags() async throws {
        // Given
        let input = "<p>Hello, <strong>Swift</strong>! <em>Welcome</em> to HTML.</p>"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "Hello, Swift! Welcome to HTML.")
    }

    @Test("When string contains nested HTML tags")
    func strippingTags_fromStringWithNestedTags() async throws {
        // Given
        let input = "<p>This is a <strong>very <em>important</em></strong> message.</p>"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "This is a very important message.")
    }

    @Test("When string contains self-closing tags")
    func strippingTags_fromStringWithSelfClosingTags() async throws {
        // Given
        let input = "<p>Here’s a list of characters: <ul><li>Tom</li><li>Jerry</li><li>Nibbles</li></ul><hr /></p>"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "Here’s a list of characters: TomJerryNibbles")
    }

    @Test("When string contains unclosed tags")
    func strippingTags_fromStringWithUnclosedTags() async throws {
        // Given
        let input = "<p>This is an unclosed <strong>bold text.</p>"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "This is an unclosed bold text.")
    }

    @Test("When string contains HTML tags with attributes")
    func strippingTags_fromStringWithTagsWithAttributes() async throws {
        // Given
        let input1 = "<a href=\"https://example.com\">Click here!</a>"
        let input2 = "<a href='https://example.com'>Click here!</a>"
        // When
        let result1 = input1.strippingTags()
        let result2 = input2.strippingTags()
        // Then
        #expect(result1 == "Click here!")
        #expect(result2 == "Click here!")
    }

    @Test("When string does NOT contain HTML tags")
    func strippingTags_fromStringWithoutHTMLTags() async throws {
        // Given
        let input = "Plain text without HTML tags"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "Plain text without HTML tags")
    }

    @Test("When string is empty")
    func strippingTags_fromEmptyString() async throws {
        // Given
        let input = ""
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "")
    }

    @Test("When string contains only HTML tags")
    func strippingTags_fromStringWithOnlyHTMLTags() async throws {
        // Given
        let input = "<html><head><title></title></head><body></body></html>"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "")
    }

    @Test("When string contains special characters within tags")
    func strippingTags_fromStringWithSpecialCharactersInTags() async throws {
        // Given
        let input = "<div>&lt;Special&gt; &amp; Characters</div>"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "&lt;Special&gt; &amp; Characters")
    }

    @Test("When string contains invalid HTML structure")
    func strippingTags_fromStringWithInvalidHTML() async throws {
        // Given
        let input = "<div><p>Invalid HTML structure"
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "Invalid HTML structure")
    }

    @Test("When string contains multiple lines with tags")
    func strippingTags_fromMultiLineStringWithTags() async throws {
        // Given (notice one 'space' before each name)
        let input = """
               <div>
                <p>Tom</p>
                <p>Jerry</p>
                <p>Nibbles</p>
               </div>
               """
        // When
        let result = input.strippingTags()
        // Then
        #expect(result == "\n Tom\n Jerry\n Nibbles\n")
    }

    @Test("When string contains script or style tags")
    func strippingTags_fromStringWithScriptOrStyleTags() async throws {
        // Given
        let input = """
               <script>alert('Hello');</script><style>body { color: red; }</style>
               <p>Hello Swift! I am HTML</p>
               """
        // When
        let result = input.strippingTags()
        // Then
        // Then
        #expect(result == "alert(\'Hello\');body { color: red; }\nHello Swift! I am HTML")
    }
}
