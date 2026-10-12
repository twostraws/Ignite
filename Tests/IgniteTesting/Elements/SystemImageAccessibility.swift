import Foundation
import SwiftSoup
import Testing

@testable import Ignite

@Suite("System image accessibility")
struct SystemImageAccessibilityTests {
    @Test("System image descriptions become accessible names", .publishingContext(), arguments: [
        "Safari logo",
        #"Taylor's "social" & support <links>"#
    ])
    func descriptionProvidesAccessibleName(description: String) async throws {
        let markup = Image(systemName: "browser-safari", description: description).markup().string
        let document = try SwiftSoup.parse(markup)
        let icon = try #require(document.select("i").first())

        #expect(try icon.attr("role") == "img")
        #expect(try icon.attr("aria-label") == description)
        #expect(try icon.attr("class") == "bi-browser-safari")
        #expect(icon.getAttributes()?.size() == 3)
    }

    @Test("System image accessibilityLabel replaces its description", .publishingContext())
    func accessibilityLabelReplacesDescription() async throws {
        let description = #"Visit "Support" & help"#
        let markup = Image(systemName: "question-circle", description: "Original description")
            .accessibilityLabel(description)
            .markup().string
        let document = try SwiftSoup.parse(markup)
        let icon = try #require(document.select("i").first())

        #expect(try icon.attr("role") == "img")
        #expect(try icon.attr("aria-label") == description)
        #expect(icon.getAttributes()?.size() == 3)
    }

    @Test("Explicit ARIA labels remain authoritative", .publishingContext())
    func explicitAriaLabelIsPreserved() async throws {
        let markup = Image(systemName: "person", description: "Profile")
            .aria(.label, "Account settings")
            .markup().string
        let document = try SwiftSoup.parse(markup)
        let icon = try #require(document.select("i").first())

        #expect(try icon.attr("aria-label") == "Account settings")
        #expect(markup.components(separatedBy: "aria-label=").count == 2)
    }

    @Test("Explicit custom roles and labels are preserved without duplicates", .publishingContext())
    func explicitCustomAttributesArePreserved() async throws {
        let markup = Image(systemName: "person", description: "Profile")
            .attribute("role", "button")
            .attribute("aria-label", "Account settings")
            .markup().string
        let document = try SwiftSoup.parse(markup)
        let icon = try #require(document.select("i").first())

        #expect(try icon.attr("role") == "button")
        #expect(try icon.attr("aria-label") == "Account settings")
        #expect(markup.components(separatedBy: "role=").count == 2)
        #expect(markup.components(separatedBy: "aria-label=").count == 2)
    }

    @Test("Unlabeled and empty-description system images keep their markup", .publishingContext(), arguments: [nil, ""] as [String?])
    func unlabeledIconsRemainUnchanged(description: String?) async throws {
        let markup = Image(systemName: "star", description: description).markup().string

        #expect(markup == #"<i class="bi-star"></i>"#)
    }

    @Test("Decorative file images retain an empty alternative description", .publishingContext())
    func decorativeFileImageRemainsUnchanged() async throws {
        let markup = Image(decorative: "/images/background.png").markup().string
        let document = try SwiftSoup.parse(markup)
        let image = try #require(document.select("img").first())

        #expect(try image.attr("alt") == "")
        #expect(!image.hasAttr("role"))
        #expect(!image.hasAttr("aria-label"))
    }
}
