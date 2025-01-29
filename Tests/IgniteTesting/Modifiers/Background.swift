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
    static let testColorNames = ["white", "black", "red", "green", "blue"]
    static let testColors: [Color] = [.white, .black, .red, .green, .blue]

    static let testRGBs = [
        "rgb(255 255 255 / 100%)",
        "rgb(0 0 0 / 100%)",
        "rgb(255 0 0 / 100%)",
        "rgb(0 128 0 / 100%)",
        "rgb(0 0 255 / 100%)"
    ]

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

    @Test("Color Background Test", arguments: zip(await Self.testColors, await Self.testRGBs))
    func colorBackground(color: Color, value: String) async throws {
        let element = Text("Hello").background(color)

        let output = element.render()

        #expect(output == "<p style=\"background-color: \(value)\">Hello</p>")
    }

    @Test("String Background Test", arguments: await Self.testColorNames)
    func colorBackground(string: String) async throws {
        let element = Text("Hello").background(string)

        let output = element.render()

        #expect(output == "<p style=\"background-color: \(string)\">Hello</p>")
    }

    @Test("Material Background Test", arguments: await Self.testMaterial)
    func materialBackground(material: Material) async throws {
        let element = Text("Hello").background(material)

        let output = element.render()

        #expect(output == "<p class=\"\(material.className)\">Hello</p>")
    }

    @Test("Gradient Background Test", arguments: await Self.testGradient)
    func gradientBackground(gradient: Gradient) async throws {
        let element = Text("Hello").background(gradient)

        let output = element.render()

        #expect(output == "<p style=\"background-image: \(gradient.description)\">Hello</p>")
    }
}
