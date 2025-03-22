//
//  HStack.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `HStack` element.
@Suite("HStack Tests")
@MainActor
class HStackTests: IgniteTestSuite {
    @Test("HStack with elements")
    func basicHStack() async throws {
        let element = HStack(alignment: .top) {
            FormFieldLabel(text: "Top Label")
            FormFieldLabel(text: "Bottom Label")
        }
        let output = element.render()

        #expect(output == """
        <div class="hstack gap-3">\
        <label class="mb-0 align-self-start">Top Label</label>\
        <label class="mb-0 align-self-start">Bottom Label</label>\
        </div>
        """)
    }

    @Test("HStack with elements and spacing")
    func elementsWithSpacingWithinHStack() async throws {
        let element = HStack(spacing: 10) {
            FormFieldLabel(text: "Top Label")
            FormFieldLabel(text: "Bottom Label")
        }
        let output = element.render()

        #expect(output == """
        <div class="hstack" style="gap: 10px">\
        <label class="mb-0 align-self-center">Top Label</label>\
        <label class="mb-0 align-self-center">Bottom Label</label>\
        </div>
        """)
    }
}
