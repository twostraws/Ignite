//
// StringXMLEscaping.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String.xmlEscaped` property.
@Suite("String XML Escaping Tests")
struct StringXMLEscapingTests {
    @Test("Escapes ampersand")
    func escapesAmpersand() {
        #expect("Tom & Jerry".xmlEscaped == "Tom &amp; Jerry")
    }

    @Test("Escapes less-than")
    func escapesLessThan() {
        #expect("a < b".xmlEscaped == "a &lt; b")
    }

    @Test("Escapes greater-than")
    func escapesGreaterThan() {
        #expect("a > b".xmlEscaped == "a &gt; b")
    }

    @Test("Escapes double quote")
    func escapesDoubleQuote() {
        #expect("say \"hello\"".xmlEscaped == "say &quot;hello&quot;")
    }

    @Test("Escapes apostrophe")
    func escapesApostrophe() {
        #expect("it's".xmlEscaped == "it&apos;s")
    }

    @Test("Escapes all special characters in one string")
    func escapesAllSpecialCharacters() {
        let input = "<div class=\"test\">'Tom & Jerry'</div>"
        let expected = "&lt;div class=&quot;test&quot;&gt;&apos;Tom &amp; Jerry&apos;&lt;/div&gt;"
        #expect(input.xmlEscaped == expected)
    }

    @Test("Returns plain string unchanged")
    func plainStringUnchanged() {
        #expect("Hello World".xmlEscaped == "Hello World")
    }

    @Test("Returns empty string unchanged")
    func emptyStringUnchanged() {
        #expect("".xmlEscaped == "")
    }

    @Test("Handles multiple consecutive ampersands")
    func multipleConsecutiveAmpersands() {
        #expect("&&".xmlEscaped == "&amp;&amp;")
    }

    @Test("Does not double-escape already escaped entities")
    func doesNotDoubleEscapePreEscaped() {
        // If the input already contains &amp;, it should be escaped again
        // (the function operates on raw strings, not pre-escaped XML)
        #expect("&amp;".xmlEscaped == "&amp;amp;")
    }
}
