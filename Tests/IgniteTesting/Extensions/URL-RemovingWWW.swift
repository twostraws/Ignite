//
//  URL-RemovingWWW.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `URL-RemovingWWW` extension.
@Suite("URL-RemovingWWW Tests")
@MainActor
struct URLRemovingWWWTests {
    @Test("Test case when URL contains 'www'")
    func testRemovingWWW_fromURLWithWWW() async throws {
        // Given
        let url = URL(string: "https://www.example.com")!
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "example.com")
    }

    @Test("Test case when URL does NOT contain 'www")
    func testRemovingWWW_fromURLWithoutWWW() async throws {
        // Given
        let url = URL(string: "https://example.com")!
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "example.com")
    }

    @Test("Test case when URL contains 'www' in the subdomain")
    func testRemovingWWW_fromURLWithSubdomain() async throws {
        // Given
        let url1 = URL(string: "https://www.blog.example.com")!
        let url2 = URL(string: "https://www.longersubdomain.blog.example.com")!
        // When
        let result1 = url1.removingWWW
        let result2 = url2.removingWWW
        // Then
        #expect(result1 == "blog.example.com")
        #expect(result2 == "longersubdomain.blog.example.com")
    }

    @Test("Test case when URL contains 'www' and also contains a path")
    func testRemovingWWW_fromURLWithPath() async throws {
        // Given
        let url = URL(string: "https://www.example.com/path/to/resource")!
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "example.com") // ignores path
    }

    @Test("Test case when URL has an invalid scheme")
    func testRemovingWWW_fromURLWithInvalidScheme() async throws {
        // Given
        let url = URL(string: "htp://www.example.com")! // host extraction will succeed
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "example.com")
    }

    @Test("Test case when URL contains www in domain or subdomain")
    func testRemovingWWW_fromURLWithWWWInDomainOrSubdomain() async throws {
        // Given
        let url1 = URL(string: "https://wwwmywww.example.com")!
        let url2 = URL(string: "https://www.mysecretwww.com")!
        let url3 = URL(string: "https://www.www.com")!
        // When
        let result1 = url1.removingWWW
        let result2 = url2.removingWWW
        let result3 = url3.removingWWW
        // Then
        #expect(result1 == "wwwmywww.example.com")
        #expect(result2 == "mysecretwww.com")
        #expect(result3 == "www.com")
    }

    @Test("Test case when URL contains an empty host")
    func testRemovingWWW_fromURLWithEmptyHost() async throws {
        // Given
        let url = URL(string: "https://www.")!
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "")
    }
}
