//
//  Spacer.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Spacer` element.
@Suite("Spacer Tests")
@MainActor
class SpacerTests: IgniteTestSuite {
    @Test("SpacerTest")
    func basicSpacerTest() async throws {
        let element = Spacer()
        let output = element.markupString()

        #expect(output == "<div class=\"mt-auto\"></div>")
    }

    @Test("Spacer with exact pixel size produces frame height")
    func exactPixelSize() async throws {
        let element = Spacer(size: 50)
        let output = element.markupString()
        #expect(output.contains("height: 50px"))
    }

    @Test("Spacer with semantic size produces margin")
    func semanticSize() async throws {
        let element = Spacer(size: .large)
        let output = element.markupString()
        #expect(output.contains("mt-4"))
    }

    @Test("Spacer with horizontal axis uses ms-auto instead of mt-auto")
    func horizontalAxis() async throws {
        let element = Spacer().axis(.horizontal)
        let output = element.markupString()
        #expect(output.contains("ms-auto"))
        #expect(!output.contains("mt-auto"))
    }

    @Test("Spacer with exact size and horizontal axis produces frame width")
    func exactPixelHorizontal() async throws {
        let element = Spacer(size: 30).axis(.horizontal)
        let output = element.markupString()
        #expect(output.contains("width: 30px"))
    }
}
