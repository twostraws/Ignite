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
            ControlLabel("Top Label")
            ControlLabel("Bottom Label")
        }
        let output = element.markupString()

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
            ControlLabel("Top Label")
            ControlLabel("Bottom Label")
        }
        let output = element.markupString()

        #expect(output == """
        <div class="vstack" style="gap: 10px">\
        <label class="mb-0 align-self-center">Top Label</label>\
        <label class="mb-0 align-self-center">Bottom Label</label>\
        </div>
        """)
    }

    @Test("VStack with leading alignment uses align-self-start")
    func leadingAlignment() async throws {
        let element = VStack(alignment: .leading) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self-start"))
    }

    @Test("VStack with trailing alignment uses align-self-end")
    func trailingAlignment() async throws {
        let element = VStack(alignment: .trailing) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self-end"))
    }

    @Test("VStack with semantic spacing uses gap class")
    func semanticSpacing() async throws {
        let element = VStack(spacing: .large) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("gap-4"))
    }

    @Test("VStack with nil spacing preserves implicit margins by omitting mb-0")
    func nilSpacingPreservesMargins() async throws {
        let element = VStack(spacing: nil) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(!output.contains("mb-0"))
    }
}
