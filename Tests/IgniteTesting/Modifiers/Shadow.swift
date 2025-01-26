//
//  Shadow.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Shadow` modifier.
@Suite("Shadow Tests")
@MainActor
struct ShadowTests {
    @Test("ShadowModifierTest")
    func radiusFiveSpanShadowTest() async throws {
        let element = Span("Hello").shadow(radius: 5)
        let output = element.render()

        #expect(output == "<span style=\"box-shadow: rgb(0 0 0 / 33%) 0px 0px 5px \">Hello</span>")
    }

    @Test("ShadowModifierTest")
    func basicTextRadiusTwentyTest() async throws {
        let element = Text("Hello").shadow(radius: 20)
        let output = element.render()

        #expect(output == "<p style=\"box-shadow: rgb(0 0 0 / 33%) 0px 0px 20px \">Hello</p>")
    }
}
