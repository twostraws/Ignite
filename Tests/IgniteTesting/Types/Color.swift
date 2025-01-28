//
//  Color.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Color` type.
@Suite("Color Tests")
@MainActor
struct ColorTests {
    @Test("foregroundStyleIsBlack")
    func foregroundStyleIsBlack() async throws {
        let foregroundStyleIsBlack = Text("Hello, world!")
            .foregroundStyle(.black)

        let output = foregroundStyleIsBlack.render()

        #expect(output == """
        <p style="color: rgb(0 0 0 / 100%)">Hello, world!</p>
        """)
    }
}
