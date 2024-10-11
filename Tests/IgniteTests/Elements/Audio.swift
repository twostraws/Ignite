    //
    // Audio.swift
    // Ignite
    // https://www.github.com/twostraws/Ignite
    // See LICENSE for license information.
    //

import Foundation

import XCTest
@testable import Ignite

    /// Tests for the `Audio` element.
final class AudioTests: ElementTest {
    func test_loneFileAudio() {
        let element = Audio("/audio/example.mp3")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output,
        """
        <audio controls>
        <source src="/audio/example.mp3" type="audio/mp3">
        Your browser does not support the audio element.
        </audio>
        """)
    }
    func test_multiFileAudio() {
        let element = Audio("/audio/example1.mp3", "/audio/example2.m4a")
        let output = element.render(context: publishingContext)

        XCTAssertEqual(output,
        """
        <audio controls><source src="/audio/example1.mp3" type="audio/mp3"><source src="/audio/example2.m4a" type="audio/m4a">Your browser does not support the audio element.</audio>
        """)
    }
}
