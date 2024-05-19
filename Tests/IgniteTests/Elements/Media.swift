    //
    // Media.swift
    // Ignite
    // https://www.github.com/twostraws/Ignite
    // See LICENSE for license information.
    //

import Foundation

import XCTest
@testable import Ignite

    /// Tests for the `Media` element.
final class MediaTests: ElementTest {
    func test_loneFileVideo() {
        let element = Media("/videos/example.mp4", "video/mp4")
        let output = element.render(context: publishingContext)
        
        XCTAssertEqual(output,
        """
        <video controls>
        <source src="/videos/example.mp4" type="video/mp4">
        Your browser does not support the video tag.
        </video>
        """)
    }
    
    func test_multiFileVideo() {
        let element = Media(["/videos/example1.mp4", "/videos/example2.mov"], ["video/mp4", "video/mov"])
        let output = element.render(context: publishingContext)
        
        XCTAssertEqual(output,
        """
        <video controls><source src="/videos/example1.mp4" type="video/mp4"><source src="/videos/example2.mov" type="video/mov">Your browser does not support the video tag.</video>
        """)
    }
    func test_loneFileAudio() {
        let element = Media("/audio/example.mp3", "audio/mp3")
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
        let element = Media(["/audio/example1.mp3", "/audio/example2.m4a"], ["audio/mp3", "audio/m4a"])
        let output = element.render(context: publishingContext)
        
        XCTAssertEqual(output,
        """
        <audio controls><source src="/audio/example1.mp3" type="audio/mp3"><source src="/audio/example2.m4a" type="audio/m4a">Your browser does not support the audio element.</audio>
        """)
    }
}
