//
// URL-DecodedPath.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `URL-DecodedPath` extension.
@Suite("URL-DecodedPath Tests")
struct Test {
    @Test("returns empty String for empty path", arguments: [
        "https://ignitesamples.hackingwithswift.com",
        "https://github.com"])
    func test_empty_path(_ string: String) async throws {
        let sut = URL(string: string)!

        #expect(sut.decodedPath.isEmpty)
    }

    @Test("returns the original path if there are no percent-encoded characters", arguments: [
        "https://docs.google.com/spreadsheets/d/135Rg3t4dCXWnzuujkmHIbNF4dOWwGbQ0j39-53M2Tko/edit?gid=0#gid=0",
        "https://ignitesamples.hackingwithswift.com/carousel-examples/"])
    func test_non_percent_encoded(_ string: String) async throws {
        let sut = URL(string: string)!

        #expect(sut.decodedPath == sut.path())
    }

    // see https://en.wikipedia.org/wiki/Percent-encoding
    @Test("returns the path with percent-encoded instances replaced", arguments: [
        ("https://docs.google.com/%21%23%24%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D",
         "/!#$&'()*+,/:;=?@[]")])
    func test_non_percent_encoded(_ instance: (String, String)) async throws {
        let sut = URL(string: instance.0)!

        #expect(sut.decodedPath == instance.1)
    }
}
