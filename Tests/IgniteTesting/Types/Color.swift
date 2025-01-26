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
    @Test("foregroundStyleisBlack")

    func foregroundStyleisBlack() async throws {
        let foregroundStyleisBlack = Text("Hello, world!")
            .foregroundStyle(.black)

        let output = foregroundStyleisBlack.render()

        #expect(output ==
        """
        <p style="color: rgb(0 0 0 / 100%)">Hello, world!</p>
        """
        )
    }
}
