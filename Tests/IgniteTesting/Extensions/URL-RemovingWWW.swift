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
    @Test("URL contains 'www'")
    func removingWWW_fromURLWithWWW() async throws {
        // Given
        let url = URL(string: "https://www.example.com")!
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "example.com")
    }

    @Test("URL does NOT contain 'www")
    func removingWWW_fromURLWithoutWWW() async throws {
        // Given
        let url = URL(string: "https://example.com")!
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "example.com")
    }

    @Test("URL contains 'www' in the subdomain")
    func removingWWW_fromURLWithSubdomain() async throws {
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

    @Test("URL contains 'www' and also contains a path")
    func removingWWW_fromURLWithPath() async throws {
        // Given
        let url = URL(string: "https://www.example.com/path/to/resource")!
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "example.com") // ignores path
    }

    @Test("URL has an invalid scheme")
    func removingWWW_fromURLWithInvalidScheme() async throws {
        // Given
        let url = URL(string: "htp://www.example.com")! // host extraction will succeed
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "example.com")
    }

    @Test(" URL contains www in domain or subdomain")
    func removingWWW_fromURLWithWWWInDomainOrSubdomain() async throws {
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

    @Test("URL contains an empty host")
    func removingWWW_fromURLWithEmptyHost() async throws {
        // Given
        let url = URL(string: "https://www.")!
        // When
        let result = url.removingWWW
        // Then
        #expect(result == "")
    }
}
