//
// SubsiteLink.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import XCTest

@testable import Ignite

/// Tests for the `title` element.
@MainActor final class SubsiteLinkTests: ElementTest {
    func test_string_target() {
        let element = Link("Go Home", target: "/")
        let output = element.render(context: publishingSubsiteContext)

        XCTAssertEqual(
            output,
            "<a href=\"/subsite/\" class=\"link-underline-opacity-100 link-underline-opacity-100-hover\">Go Home</a>"
        )
    }

    func test_page_target() {
        let element = Link("This is a test", target: TestPage()).linkStyle(
            .button)
        let output = element.render(context: publishingSubsiteContext)

        XCTAssertEqual(
            output,
            "<a href=\"/subsite/test-page\" class=\"btn btn-primary\">This is a test</a>"
        )
    }

    func test_page_content() {
        let element = Link(target: TestPage()) {
            "MORE "
            Text("CONTENT")
        }
        let output = element.render(context: publishingSubsiteContext)

        XCTAssertEqual(
            output,
            "<a href=\"/subsite/test-page\" class=\"link-plain link-underline-opacity-100 link-underline-opacity-100-hover\">MORE <p>CONTENT</p></a>"
        )
    }
}
