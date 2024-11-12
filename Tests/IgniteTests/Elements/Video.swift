//
// Video.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

@testable import Ignite
import XCTest

// swiftlint:disable line_length
/// Tests for the `Video` element.
@MainActor final class VideoTests: ElementTest {
    func test_loneFileVideo() {
        let element = Video("/videos/example.mp4")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, """
        <video controls><source src="/videos/example.mp4" type="video/mp4">Your browser does not support the video tag.</video>
        """)
    }

    func test_multiFileVideo() {
        let element = Video("/videos/example1.mp4", "/videos/example2.mov")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output, """
        <video controls><source src="/videos/example1.mp4" type="video/mp4"><source src="/videos/example2.mov" type="video/quicktime">Your browser does not support the video tag.</video>
        """)
    }
}

// swiftlint:enable line_length
