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
            ControlLabel("Top Label")
            ControlLabel("Bottom Label")
        }
        let output = element.markupString()

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
            ControlLabel("Top Label")
            ControlLabel("Bottom Label")
        }
        let output = element.markupString()

        #expect(output == """
        <div class="hstack" style="gap: 10px">\
        <label class="mb-0 align-self-center">Top Label</label>\
        <label class="mb-0 align-self-center">Bottom Label</label>\
        </div>
        """)
    }

    @Test("HStack with bottom alignment uses align-self-end")
    func bottomAlignment() async throws {
        let element = HStack(alignment: .bottom) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self-end"))
    }

    @Test("HStack with semantic spacing uses gap class")
    func semanticSpacing() async throws {
        let element = HStack(spacing: .large) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("gap-4"))
    }

    @Test("HStack with spacing none omits gap class")
    func spacingNone() async throws {
        let element = HStack(spacing: .none) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("hstack"))
        #expect(!output.contains("gap-"))
        #expect(!output.contains("gap:"))
    }
}
