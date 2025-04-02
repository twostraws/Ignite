//
// Label.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Label` element.
@Suite("Label Tests")
@MainActor
class LabelTests: IgniteTestSuite {
    @Test("Basic Label")
    func basicLabel() async throws {
        let element = Label("Logo", image: "/images/logo.png")
        let output = element.render()

        #expect(output == """
        <span style="display: inline-flex; align-items: center">\
        <img src="/images/logo.png" alt="Logo" style="margin-right: 10px" />\
        Logo\
        </span>
        """)
    }
}
