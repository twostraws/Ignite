//
// LinkNavigationState.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing
@testable import Ignite

/// Local page canonicalization must not alter query values or fragment identifiers.
@Suite("Link Navigation State Tests")
class LinkNavigationStateTests: IgniteTestSuite {
    static let sites: [TestPublishingSite] = [
        .standard, .relativePaths, .subsite, .relativePathsSubsite
    ]

    // Expected paths are literal fixtures so the test does not reuse linkPath's algorithm.
    static let targets: [(target: String, absolute: String, relative: String)] = [
        ("/privacy", "/privacy/", "privacy/"),
        ("privacy", "privacy/", "privacy/"),
        ("/privacy/", "/privacy/", "privacy/"),
        ("/", "/", "/"),
        ("/privacy?campaign=preview", "/privacy/?campaign=preview", "privacy/?campaign=preview"),
        (
            "/privacy/?campaign=hello%20world",
            "/privacy/?campaign=hello%20world",
            "privacy/?campaign=hello%20world"
        ),
        ("/privacy#details", "/privacy/#details", "privacy/#details"),
        (
            "/privacy/?campaign=preview#details",
            "/privacy/?campaign=preview#details",
            "privacy/?campaign=preview#details"
        ),
        ("/privacy?campaign=v1.2", "/privacy/?campaign=v1.2", "privacy/?campaign=v1.2"),
        ("/privacy#part/one", "/privacy/#part/one", "privacy/#part/one"),
        ("/privacy?next=/offers/", "/privacy/?next=/offers/", "privacy/?next=/offers/"),
        (
            "/privacy.html?campaign=preview",
            "/privacy.html?campaign=preview",
            "privacy.html?campaign=preview"
        ),
        ("/assets/guide.pdf#page=2", "/assets/guide.pdf#page=2", "assets/guide.pdf#page=2"),
        ("/?campaign=preview", "/?campaign=preview", "?campaign=preview"),
        ("?campaign=preview", "?campaign=preview", "?campaign=preview"),
        ("#details", "#details", "#details"),
        (
            "/privacy?campaign=hello%20world&next=%2Foffer%3Fcode%3Dabc%26x%3D1#part%202",
            "/privacy/?campaign=hello%20world&next=%2Foffer%3Fcode%3Dabc%26x%3D1#part%202",
            "privacy/?campaign=hello%20world&next=%2Foffer%3Fcode%3Dabc%26x%3D1#part%202"
        ),
        (
            "/privacy%3Fdraft%23notes?campaign=preview",
            "/privacy%3Fdraft%23notes/?campaign=preview",
            "privacy%3Fdraft%23notes/?campaign=preview"
        ),
        ("/privacy?#", "/privacy/?#", "privacy/?#"),
        (
            "http://outside.example/path?campaign=preview#details",
            "http://outside.example/path?campaign=preview#details",
            "http://outside.example/path?campaign=preview#details"
        ),
        (
            "https://outside.example/path?campaign=preview#details",
            "https://outside.example/path?campaign=preview#details",
            "https://outside.example/path?campaign=preview#details"
        ),
        (
            "mailto:editor@example.com?subject=Hello%20world",
            "mailto:editor@example.com?subject=Hello%20world",
            "mailto:editor@example.com?subject=Hello%20world"
        )
    ]

    @Test("Link preserves query and fragment while canonicalizing the page path", .publishingContext(), arguments: targets, sites)
    func preservesNavigationState(
        target: (target: String, absolute: String, relative: String),
        siteCase: TestPublishingSite
    ) throws {
        let expectedPath: String = switch siteCase {
        case .standard, .subsite: target.absolute
        case .relativePaths, .relativePathsSubsite: target.relative
        }

        let output = try withPublishingContext(for: siteCase.site) { _ in
            Link("Read more", target: target.target).markupString()
        }

        #expect(output == "<a href=\"\(expectedPath)\">Read more</a>")
    }

    @Test("Empty link targets preserve existing empty output", .publishingContext(), arguments: sites)
    func emptyTarget(siteCase: TestPublishingSite) throws {
        let output = try withPublishingContext(for: siteCase.site) { _ in
            Link("Read more", target: "").markupString()
        }

        #expect(output.isEmpty)
    }

}
