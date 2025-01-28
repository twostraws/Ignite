//
//  String-AbsoluteLinks.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-AbsoluteLinks` extension.
@Suite("String-AbsoluteLinks Tests")
@MainActor
struct StringAbsoluteLinksTests {
    let baseURL = URL(string: "https://example.com")!
    @Test("Absolute links for simple paths")
    func makingAbsoluteLinks_forSimplePaths() async throws {
        // Given
        let html = """
        <img src="/images/pic1.jpg">
        <a href="/about">About Us</a>
        """
        let expectedAbsoluteLink1 = "https://example.com/images/pic1.jpg"
        let expectedAbsoluteLink2 = "https://example.com/about"
        // When
        let result = html.makingAbsoluteLinks(relativeTo: baseURL)
        // Then
        #expect(result.contains("src=\"\(expectedAbsoluteLink1)"))
        #expect(result.contains("href=\"\(expectedAbsoluteLink2)"))
    }

    @Test("Absolute links for mixed absolute and relative paths")
    func makingAbsoluteLinks_forMixedAbsoluteAndRelativePaths() async throws {
        // Given
        let html = """
        <img src="/images/pic1.jpg">
        <a href="/contact">Contact</a>
        <img src="https://example.com/images/pic2.jpg">
        <a href="https://example.com/about">About</a>
        """
        let expectedAbsoluteLink1 = "https://example.com/images/pic1.jpg"
        let expectedAbsoluteLink2 = "https://example.com/contact"
        let expectedAbsoluteLink3 = "https://example.com/images/pic2.jpg"
        let expectedAbsoluteLink4 = "https://example.com/about"
        // When
        let result = html.makingAbsoluteLinks(relativeTo: baseURL)
        // Then
        #expect(result.contains("src=\"\(expectedAbsoluteLink1)"))
        #expect(result.contains("href=\"\(expectedAbsoluteLink2)"))
        #expect(result.contains("src=\"\(expectedAbsoluteLink3)"))
        #expect(result.contains("href=\"\(expectedAbsoluteLink4)"))
    }

    @Test("Absolute links for paths that don't start with a slash")
    func makingAbsoluteLinks_forPathsThatDontStartWithASlash() async throws {
        // Given
        let html = """
        <img src="pic1.jpg">
        <a href="about">About Us</a>
        """
        let expectedAbsoluteLink1 = "pic1.jpg"
        let expectedAbsoluteLink2 = "about"
        // When
        let result = html.makingAbsoluteLinks(relativeTo: baseURL)
        // Then
        #expect(result.contains("src=\"\(expectedAbsoluteLink1)"))
        #expect(result.contains("href=\"\(expectedAbsoluteLink2)"))
        #expect(result == html) // basically, no change
    }

    @Test("Absolute links for URLs with query parameters and fragments")
    func makingAbsoluteLinks_forURLsWithQueriesAndFragments() async throws {
        // Note: (%3F is '?', %23 is '#')
        // Given
        let html = """
        <img src="/images/pic1.jpg?version=1.2#anchor">
        <a href="/about?page=2">About Us</a>
        <a href="/search?query=swift&sort=version">Swift Versions</a>
        """
        let expectedAbsoluteLink1 = "https://example.com/images/pic1.jpg%3Fversion=1.2%23anchor"
        let expectedAbsoluteLink2 = "https://example.com/about%3Fpage=2"
        let expectedAbsoluteLink3 = "https://example.com/search%3Fquery=swift&sort=version"
        // When
        let result = html.makingAbsoluteLinks(relativeTo: baseURL)
        // Then
        #expect(result.contains("src=\"\(expectedAbsoluteLink1)"))
        #expect(result.contains("href=\"\(expectedAbsoluteLink2)"))
        #expect(result.contains("href=\"\(expectedAbsoluteLink3)"))
    }

    @Test("Absolute links for an invalid base URL")
    func makingAbsoluteLinks_forAnInvalidBaseURL() async throws {
        // Given
        let invalidBaseURL = URL(string: "not a url")
        let html = """
        <img src="/images/pic1.jpg">
        <a href="/about">About Us</a>
        """
        let expectedAbsoluteLink = "not%20a%20url/images/pic1.jpg"
        // When
        let result = html.makingAbsoluteLinks(relativeTo: invalidBaseURL!)
        // Then
        #expect(result.contains("src=\"\(expectedAbsoluteLink)"))
    }

    @Test("Absolute links for empty HTML")
    func makingAbsoluteLinks_forEmptyHTML() async throws {
        // Given
        let html = ""
        // When
        let result = html.makingAbsoluteLinks(relativeTo: baseURL)
        // Then
        #expect(result == "")
    }

    @Test("Absolute links for html with no src or href attributes")
    func makingAbsoluteLinks_forHTMLWithoutLinksOrImages() async throws {
        // Given
        let html = "<div>Hello, world!</div>"
        // When
        let result = html.makingAbsoluteLinks(relativeTo: baseURL)
        // Then
        #expect(result == html) // HTML remains unchanged
    }

    @Test("Absolute links for missing end quotes in HTML path")
    func makingAbsoluteLinks_forMissingEndQuotesInHTMLPath() async throws {
        // Note: (%3E is '>')
        // Given
        let html1 = "<img src=\"/images/pic1.jpg>"
        let html2 = "<a href=\"/about>"
        let expectedAbsoluteLink1 = "https://example.com/images/pic1.jpg"
        let expectedAbsoluteLink2 = "https://example.com/about"
        // When
        let result1 = html1.makingAbsoluteLinks(relativeTo: baseURL)
        let result2 = html2.makingAbsoluteLinks(relativeTo: baseURL)
        // Then
        #expect(result1.contains("src=\"\(expectedAbsoluteLink1)%3E"))
        #expect(result2.contains("href=\"\(expectedAbsoluteLink2)%3E"))
    }
}
