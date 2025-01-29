//
//  Background.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Background` modifier.
@Suite("Background Tests")
@MainActor
struct BackgroundTests {
    @Test("Background modifier with Color on Text")
    func textWithColorBackground() async throws {
        let element = Text("Hello, world!").background(.teal)
        let output = element.render()

        #expect(output == "<p style=\"background-color: rgb(0 128 128 / 100%)\">Hello, world!</p>")
    }

    @Test("Background modifier with colorstring on Text")
    func textWithColorStringBackground() async throws {
        let element = Text("Hello, world!").background("Tomato")
        let output = element.render()

        #expect(output == "<p style=\"background-color: Tomato\">Hello, world!</p>")
    }

    @Test("Background modifier with thinMaterial on Text")
    func textWithMaterialBackground() async throws {
        let element = Text("Hello, world!").background(.thinMaterial)
        let output = element.render()

        #expect(output == "<p class=\"material-thin\">Hello, world!</p>")
    }

    @Test func textWithGradientBackground() async throws {
        let gradient = Gradient(
            colors: [.red, .green, .yellow],
            type: .linear(angle: 90)
        )
        let element = Text("Hello, world!").background(gradient)
        let output = element.render()

        #expect(output == """
<p style=\"background-image: linear-gradient(90deg, \
rgb(255 0 0 / 100%) 0.0%, rgb(0 128 0 / 100%) 50.0%, \
rgb(255 255 0 / 100%) 100.0%)\">Hello, world!</p>
""")
    }

}
