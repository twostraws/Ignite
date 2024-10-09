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
struct AudioTests {
    /// A publishing context with sample values for root site tests.
    let publishingContext = try! PublishingContext(for: TestSite(), from: "Test Site")
    @Test("Lone File Audio")
    func test_loneFileAudio() async throws {
        let element = Audio("/audio/example.mp3")
        let output = element.render(context: publishingContext)

        #expect(output ==
        """
        <audio controls><source src="/audio/example.mp3" type="audio/mp3">Your browser does not support the audio element.</audio>
        """)
    }
    @Test("Multiple File Audio")
    func test_multiFileAudio() async throws {
        let element = Audio("/audio/example1.mp3", "/audio/example2.wav")
        let output = element.render(context: publishingContext)

        #expect(output ==
        """
        <audio controls><source src="/audio/example1.mp3" type="audio/mp3"><source src="/audio/example2.wav" type="audio/wav">Your browser does not support the audio element.</audio>
        """)
    }
}
// swiftlint:enable line_length
