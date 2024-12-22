//
// Video.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

// swiftlint:disable line_length
/// Tests for the `Video` element.
@Suite("Video Tests")
@MainActor struct VideoTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Lone File Video Test")
    func test_loneFileVideo() async throws {
        let element = Video("/videos/example.mp4")
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)

        #expect(
            normalizedOutput
                == "<video><source src=\"/videos/example.mp4\" type=\"video/mp4\"/>Your browser does not support the video tag.</video>"
        )
    }
    @Test("Multi-file Video Test")
    func test_multiFileVideo() async throws {
        let element = Video("/videos/example1.mp4", "/videos/example2.mov")
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)

        #expect(
            normalizedOutput
                == "<video><source src=\"/videos/example1.mp4\" type=\"video/mp4\"/><source src=\"/videos/example2.mov\" type=\"video/quicktime\"/>Your browser does not support the video tag.</video>"
        )
    }
}
// swiftlint:enable line_length
