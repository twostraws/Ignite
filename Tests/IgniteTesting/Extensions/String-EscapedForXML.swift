//
// String-EscapedForXML.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String.escapedForXML()` extension.
@Suite("String EscapedForXML Tests")
struct StringEscapedForXMLTests {
    @Test("Escapes ampersand")
    func escapesAmpersand() {
        #expect("Tom & Jerry".escapedForXML() == "Tom &amp; Jerry")
    }

    @Test("Escapes less-than")
    func escapesLessThan() {
        #expect("a < b".escapedForXML() == "a &lt; b")
    }

    @Test("Escapes greater-than")
    func escapesGreaterThan() {
        #expect("a > b".escapedForXML() == "a &gt; b")
    }

    @Test("Escapes double quote")
    func escapesDoubleQuote() {
        #expect("say \"hello\"".escapedForXML() == "say &quot;hello&quot;")
    }

    @Test("Escapes single quote")
    func escapesSingleQuote() {
        #expect("it's".escapedForXML() == "it&apos;s")
    }

    @Test("Escapes all special characters together")
    func escapesAllSpecials() {
        let input = "<a href=\"x\">Tom & Jerry's 'Adventures' > 1</a>"
        let expected = "&lt;a href=&quot;x&quot;&gt;Tom &amp; Jerry&apos;s &apos;Adventures&apos; &gt; 1&lt;/a&gt;"
        #expect(input.escapedForXML() == expected)
    }

    @Test("Leaves plain text unchanged")
    func plainTextUnchanged() {
        #expect("Hello World".escapedForXML() == "Hello World")
    }

    @Test("Empty string remains empty")
    func emptyString() {
        #expect("".escapedForXML() == "")
    }

    @Test("Escapes consecutive ampersands")
    func consecutiveAmpersands() {
        #expect("&&".escapedForXML() == "&amp;&amp;")
    }

    /// Escaping is intentionally non-idempotent: the `&` in an existing
    /// entity reference like `&amp;` will be re-escaped. Callers must
    /// only escape raw, un-escaped text.
    @Test("Already-escaped entities are re-escaped")
    func reEscapesEntities() {
        #expect("&amp;".escapedForXML() == "&amp;amp;")
    }
}
