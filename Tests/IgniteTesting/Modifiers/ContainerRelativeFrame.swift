//
//  ContainerRelativeFrame.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Testing

@testable import Ignite

/// Tests for the `ContainerRelativeFrame` modifier.
@Suite("ContainerRelativeFrame Tests")
@MainActor
class ContainerRelativeFrameTests: IgniteTestSuite {
    @Test("Default center alignment applies flex display and centering styles")
    func defaultCenterAlignment() async throws {
        let element = Text("Centered")
            .containerRelativeFrame()

        let output = element.markupString()

        #expect(output.contains("display: flex"))
        #expect(output.contains("align-items: center"))
        #expect(output.contains("justify-content: center"))
        #expect(output.contains("width: 100%"))
        #expect(output.contains("height: 100%"))
        #expect(output.contains("overflow: hidden"))
    }

    @Test("topLeading alignment uses flex-start values")
    func topLeadingAlignment() async throws {
        let element = Text("Top Leading")
            .containerRelativeFrame(.topLeading)

        let output = element.markupString()

        #expect(output.contains("align-items: flex-start"))
        #expect(output.contains("justify-content: flex-start"))
    }

    @Test("Edge pins are applied")
    func edgePinsApplied() async throws {
        let element = Text("Pinned")
            .containerRelativeFrame()

        let output = element.markupString()

        #expect(output.contains("top: 0"))
        #expect(output.contains("right: 0"))
        #expect(output.contains("bottom: 0"))
        #expect(output.contains("left: 0"))
    }
}
