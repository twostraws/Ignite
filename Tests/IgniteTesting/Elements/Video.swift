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

    @Test("Lone File Video Test", arguments: ["/videos/example.mp4"])
    func test_loneFileVideo(videoFile: String) async throws {
        let element = Video(videoFile)
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)

        #expect(
            normalizedOutput
                == "<video><source src=\"\(videoFile)\" type=\"video/mp4\"/>Your browser does not support the video tag.</video>"
        )
    }
    @Test(
        "Multi-file Video Test", arguments: ["/videos/example1.mp4"],
        ["/videos/example1.mov"])
    func test_multiFileVideo(videoFile1: String, videoFile2: String)
        async throws {
        let element = Video(videoFile1, videoFile2)
        let output = element.render(context: publishingContext)
        let normalizedOutput = ElementTest.normalizeHTML(output)

        #expect(
            normalizedOutput
                == "<video><source src=\"\(videoFile1)\" type=\"video/mp4\"/><source src=\"\(videoFile2)\" type=\"video/quicktime\"/>Your browser does not support the video tag.</video>"
        )
    }
}
// swiftlint:enable line_length
