//
//  VStack.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `VStack` element.
@Suite("VStack Tests")
@MainActor
class VStackTests: IgniteTestSuite {
    @Test("VStack with elements")
    func basicVStack() async throws {
        let element = VStack {
            FormFieldLabel(text: "Top Label")
            FormFieldLabel(text: "Bottom Label")
        }
        let output = element.render()

        #expect(output == """
        <div class="vstack">\
        <label class="mb-0 align-self-center">Top Label</label>\
        <label class="mb-0 align-self-center">Bottom Label</label>\
        </div>
        """)
    }

    @Test("VStack with elements and spacing")
    func elementsWithSpacingWithinVStack() async throws {
        let element = VStack(spacing: 10) {
            FormFieldLabel(text: "Top Label")
            FormFieldLabel(text: "Bottom Label")
        }
        let output = element.render()

        #expect(output == """
        <div class="vstack" style="gap: 10px">\
        <label class="mb-0 align-self-center">Top Label</label>\
        <label class="mb-0 align-self-center">Bottom Label</label>\
        </div>
        """)
    }
}
