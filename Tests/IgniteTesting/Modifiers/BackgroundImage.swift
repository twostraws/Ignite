//
//  BackgroundImage.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `BackgroundImage` modifier.
@Suite("BackgroundImage Tests")
@MainActor
struct BackgroundImageTests {
    @Test("Background Image Content Mode", arguments: [
        BackgroundImageContentMode.original, .fill, .fit,
        .size(width: "25px", height: "25px")])
    func backgroundImage(contentMode: BackgroundImageContentMode) async throws {
        let element = Text {
            "Hello World!"
        }.background(image: "assets/image.png", contentMode: contentMode)
        let output = element.markupString()

        #expect(output == """
        <p \
        style="background-image: url('assets/image.png'); \
        background-size: \(contentMode.css); \
        background-repeat: no-repeat; \
        background-position: center center">Hello World!\
        </p>
        """)
    }

    @Test("Background Image Position", arguments: [
        BackgroundPosition.center, .top, .bottom, .leading, .trailing,
        .topLeading, .topTrailing, .bottomLeading, .bottomTrailing,
        .position(vertical: .pixel(25), relativeTo: .center, horizontal: .pixel(25), relativeTo: .center)
    ])
    func backgroundPosition(position: BackgroundPosition) async throws {
        let element = Text {
            "Hello World!"
        }.background(image: "assets/image.png", contentMode: .fill, position: position)
        let output = element.markupString()

        #expect(output == """
        <p \
        style=\"background-image: url('assets/image.png'); \
        background-size: cover; \
        background-repeat: no-repeat; \
        background-position: \(position.css)">Hello World!\
        </p>
        """)
    }

    @Test("Background image with repeats true produces background-repeat repeat")
    func repeatsTrue() async throws {
        let element = Text {
            "Hello World!"
        }.background(image: "assets/pattern.png", contentMode: .original, repeats: true)
        let output = element.markupString()

        #expect(output.contains("background-repeat: repeat"))
        #expect(!output.contains("no-repeat"))
    }

    @Test("Background position with percent values and non-center alignment")
    func percentRelativePosition() async throws {
        let position = BackgroundPosition.position(
            vertical: .percent(10), relativeTo: .top,
            horizontal: .percent(20), relativeTo: .leading
        )
        let element = Text {
            "Hello World!"
        }.background(image: "assets/image.png", contentMode: .fill, position: position)
        let output = element.markupString()

        #expect(output.contains("background-position: calc(0% + 20%) calc(0% + 10%)"))
    }
}
