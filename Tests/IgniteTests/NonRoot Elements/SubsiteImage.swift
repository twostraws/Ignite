//
// SubsiteImage.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite
import XCTest

/// Tests for the `Image` element.
@MainActor final class SubsiteImageTests: ElementTest {
    func test_image_named() {
        let element = Image("/images/example.jpg", description: "Example image")
        let output = element.render(context: publishingSubsiteContext)

        XCTAssertEqual(output, "<img src=\"/subsite/images/example.jpg\" alt=\"Example image\"/>")
    }

    func test_image_icon() {
        let element = Image(systemName: "browser-safari", description: "Safari logo")
        let output = element.render(context: publishingSubsiteContext)

        XCTAssertEqual(output, "<i class=\"bi-browser-safari\"></i>")
    }
}
