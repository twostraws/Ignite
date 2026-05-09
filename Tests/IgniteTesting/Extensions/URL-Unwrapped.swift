//
//  URL-Unwrapped.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `URL-Unwrapped` extension.
@Suite("URL Static Init Tests")
struct URLUnwrappedTests {
    @Test("Creates URL from valid static string", .publishingContext(), arguments: [
        "https://example.com",
        "https://www.github.com/twostraws/Ignite",
        "https://apple.com/path/to/page",
        "file:///Users/test/Documents"
    ])
    func createsURLFromValidStaticString(urlString: String) async throws {
        // We can't pass StaticString as a test argument, so we verify
        // the underlying URL(string:) behavior that the static init uses.
        let url = URL(string: urlString)
        #expect(url != nil)
        #expect(url?.absoluteString == urlString)
    }

    @Test("Valid static strings produce correct URLs", .publishingContext())
    func validStaticStringsProduceCorrectURLs() async throws {
        let url = URL(static: "https://example.com")
        #expect(url.absoluteString == "https://example.com")
    }

    @Test("Static init with path", .publishingContext())
    func staticInitWithPath() async throws {
        let url = URL(static: "https://example.com/path/to/page")
        #expect(url.host() == "example.com")
    }
}
