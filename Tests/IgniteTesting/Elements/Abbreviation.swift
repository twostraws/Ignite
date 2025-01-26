//
//  Abbreviation.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Abbreviation` element.
@Suite("Abbreviation Tests")
@MainActor
struct AbbreviationTests {
    @Test("Basic Abbreviation Test", arguments: ["abbr"], ["abbreviation"])
    func basic(abbreviation: String, description: String) async throws {
        let element = Abbreviation(abbreviation, description: description)
        let output = element.render()

        #expect(
            output == "<abbr title=\"\(description)\">\(abbreviation)</abbr>")
    }

    @Test(
        "Single Element Abbreviation Test", arguments: ["abbreviation"],
        ["abbr"])
    func singleElement(description: String, abbreviation: String)
        async throws {
        let element = Abbreviation(description) { Strong(abbreviation) }
        let output = element.render()

        #expect(
            output
                == "<abbr title=\"\(description)\"><strong>\(abbreviation)</strong></abbr>"
        )
    }

    @Test("Builder Abbreviation Test", arguments: ["abbreviation"], ["abbr"])
    func builder(description: String, abbreviation: String) async throws {
        let element = Abbreviation(description) {
            Strong {
                abbreviation
            }
        }

        let output = element.render()

        #expect(
            output
                == "<abbr title=\"\(description)\"><strong>\(abbreviation)</strong></abbr>"
        )
    }
}
