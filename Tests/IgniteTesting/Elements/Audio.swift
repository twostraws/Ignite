//
// Audio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Audio` element.
@Suite("Audio Tests")
@MainActor
class AudioTests: IgniteTestSuite {
    @Test("Lone File Audio", arguments: ["/audio/example.mp3"])
    func loneFileAudio(audioFile: String) async throws {
        let element = Audio(audioFile)
        let output = element.markupString()

        #expect(output == """
        <audio controls>\
        <source src="\(audioFile)" type="audio/mpeg">Your browser does not support the audio element.\
        </audio>
        """)
    }

    @Test("Multiple File Audio", arguments: ["/audio/example1.mp3"], ["/audio/example1.wav"])
    func multiFileAudio(audioFile1: String, audioFile2: String) async throws {
        let element = Audio(audioFile1, audioFile2)
        let output = element.markupString()

        #expect(output == """
        <audio controls>\
        <source src="\(audioFile1)" type="audio/mpeg">\
        <source src="\(audioFile2)" type="audio/wav">Your browser does not support the audio element.\
        </audio>
        """)
    }

    @Test("Unrecognized file extension produces no source tag")
    func unrecognizedExtension() async throws {
        let element = Audio("/audio/mystery.xyz")
        let output = element.markupString()

        #expect(output == """
        <audio controls>\
        Your browser does not support the audio element.\
        </audio>
        """)
    }

    @Test("Mixed recognized and unrecognized files only renders recognized sources")
    func mixedExtensions() async throws {
        let element = Audio("/audio/song.mp3", "/audio/song.xyz", "/audio/song.ogg")
        let output = element.markupString()

        #expect(output.contains(#"<source src="/audio/song.mp3" type="audio/mpeg">"#))
        #expect(output.contains(#"<source src="/audio/song.ogg" type="audio/ogg">"#))
        #expect(!output.contains("song.xyz"))
    }
}
