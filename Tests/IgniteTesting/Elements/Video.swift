//
// Video.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Video` element.
@Suite("Video Tests")
@MainActor class VideoTests: IgniteTestSuite {
    @Test("Lone File Video", arguments: ["/videos/example.mp4"])
    func loneFileVideo(videoFile: String) async throws {
        let element = Video(videoFile)
        let output = element.render()

        #expect(output == """
        <video controls>\
        <source src=\"\(videoFile)\" type=\"video/mp4\" />\
        Your browser does not support the video tag.\
        </video>
        """)
    }

    @Test("Multi-file Video", arguments: ["/videos/example1.mp4"], ["/videos/example1.mov"])
    func multiFileVideo(videoFile1: String, videoFile2: String) async throws {
        let element = Video(videoFile1, videoFile2)
        let output = element.render()

        #expect(output == """
        <video controls>\
        <source src=\"\(videoFile1)\" type=\"video/mp4\" />\
        <source src=\"\(videoFile2)\" type=\"video/quicktime\" />\
        Your browser does not support the video tag.\
        </video>
        """)
    }
}
