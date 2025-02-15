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
class BackgroundTests: IgniteTestSuite {
    static let testMaterial: [Material] = [
        .ultraThinMaterial,
        .thinMaterial,
        .regularMaterial,
        .thickMaterial,
        .ultraThickMaterial
    ]

    static let testGradient: [Gradient] = [
        Gradient(colors: [.white, .black], type: .radial),
        Gradient(colors: [.white, .black], type: .linear(angle: 10)),
        Gradient(colors: [.white, .black], type: .conic(angle: 10))
    ]

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

    @Test("Background modifier with Material on Text", arguments: await Self.testMaterial)
    func textWithMaterialBackground(material: Material) async throws {
        let element = Text("Hello, world!").background(material)
        let output = element.render()

        #expect(output == "<p class=\"\(material.className)\">Hello, world!</p>")
    }

    @Test("Gradient Background Test", arguments: await Self.testGradient)
    func textWithGradientBackground(gradient: Gradient) async throws {
        let element = Text("Hello, world!").background(gradient)
        let output = element.render()

        #expect(output == "<p style=\"background-image: \(gradient.description)\">Hello, world!</p>")
    }
}
