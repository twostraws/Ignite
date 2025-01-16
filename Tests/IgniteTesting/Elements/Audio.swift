//
// Audio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

// swiftlint:disable line_length
/// Tests for the `Audio` element.
@Suite("Audio Tests")
@MainActor struct AudioTests {
    let publishingContext = ElementTest.publishingContext

    @Test("Lone File Audio", arguments: ["/audio/example.mp3"])
    func test_loneFileAudio(audioFile: String) async throws {
        let element = Audio(audioFile)
        let output = element.render(context: publishingContext)

        #expect(
            output == """
                <audio controls><source src="\(audioFile)" type="audio/mp3">Your browser does not support the audio element.</audio>
                """)
    }
    @Test(
        "Multiple File Audio", arguments: ["/audio/example1.mp3"],
        ["/audio/example1.wav"])
    func test_multiFileAudio(audioFile1: String, audioFile2: String)
        async throws {
        let element = Audio(audioFile1, audioFile2)
        let output = element.render(context: publishingContext)

        #expect(
            output == """
                <audio controls><source src="\(audioFile1)" type="audio/mp3"><source src="\(audioFile2)" type="audio/wav">Your browser does not support the audio element.</audio>
                """)
    }
}
// swiftlint:enable line_length
