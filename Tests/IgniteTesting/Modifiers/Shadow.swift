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
class ShadowTests: IgniteTestSuite {
    @Test("Shadow Modifier", arguments: [5, 20])
    func shadowRadius(radius: Int) async throws {
        let element = Span("Hello").shadow(radius: radius)
        let output = element.render()

        #expect(output == "<span style=\"box-shadow: rgb(0 0 0 / 33%) 0px 0px \(radius)px \">Hello</span>")
    }
}
