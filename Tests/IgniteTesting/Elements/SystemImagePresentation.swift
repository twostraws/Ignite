//
// SystemImagePresentation.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import SwiftSoup
import Testing

@testable import Ignite

@Suite("System image explicit presentation")
struct SystemImagePresentationTests {
    @Test("Explicit presentational roles do not acquire accessible names", .publishingContext(), arguments: [
        "presentation", "none", "none presentation", "presentation img", "\t none \n"
    ])
    func presentationalRoleRemainsUnlabeled(role: String) async throws {
        let markup = Image(systemName: "star", description: "Star")
            .attribute("role", role)
            .markup().string
        let document = try SwiftSoup.parse(markup)
        let icon = try #require(document.select("i").first())

        #expect(try icon.attr("role") == role)
        #expect(!icon.hasAttr("aria-label"))
    }

    @Test("Explicit roles and names remain authoritative", .publishingContext(), arguments: [
        "button", "img", "button presentation", "presentation"
    ])
    func explicitRoleAndLabelRemainUnchanged(role: String) async throws {
        let markup = Image(systemName: "star", description: "Star")
            .attribute("role", role)
            .aria(.label, "Favorite")
            .markup().string
        let document = try SwiftSoup.parse(markup)
        let icon = try #require(document.select("i").first())

        #expect(try icon.attr("role") == role)
        #expect(try icon.attr("aria-label") == "Favorite")
        #expect(markup.components(separatedBy: "role=").count == 2)
        #expect(markup.components(separatedBy: "aria-label=").count == 2)
    }

    @Test("Explicitly hidden system images retain their hidden state", .publishingContext())
    func explicitlyHiddenIconRemainsHidden() async throws {
        let markup = Image(systemName: "star", description: "Star")
            .aria(.hidden, "true")
            .markup().string
        let document = try SwiftSoup.parse(markup)
        let icon = try #require(document.select("i").first())

        #expect(try icon.attr("aria-hidden") == "true")
        #expect(markup.components(separatedBy: "aria-hidden=").count == 2)
    }
}
