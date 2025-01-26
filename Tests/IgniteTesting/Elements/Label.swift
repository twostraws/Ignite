//
//  Label.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Label` element.
@Suite("Label Tests")
@MainActor
struct LabelTests {
    @Test("Basic Label")
    func basicLabel() async throws {
        let element = Label(text: "This is a text for label")
        let output = element.render()

        #expect(output == "<label>This is a text for label</label>")
    }
}
