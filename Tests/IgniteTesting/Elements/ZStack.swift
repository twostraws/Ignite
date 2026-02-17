//
//  ZStack.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `ZStack` element.
@Suite("ZStack Tests")
@MainActor
class ZStackTests: IgniteTestSuite {
    static let alignments: [Alignment] = [
        .top, .topLeading, .topTrailing,
        .leading, .center, .trailing,
        .bottom, .bottomLeading, .bottomTrailing
    ]

    @Test("ZStack with elements")
    func basicZStack() async throws {
        let element = ZStack {
            ControlLabel("Top Label")
            ControlLabel("Bottom Label")
        }
        let output = element.markupString()

        #expect(output == """
        <div style="display: grid">\
        <label class="mb-0" style="position: relative; grid-area: 1/1; \
        z-index: 0; align-self: center; justify-self: center">Top Label</label>\
        <label class="mb-0" style="position: relative; grid-area: 1/1; \
        z-index: 1; align-self: center; justify-self: center">Bottom Label</label>\
        </div>
        """)
    }

    @Test("ZStack assigns incrementing z-index to children")
    func zIndexIncrement() async throws {
        let element = ZStack {
            ControlLabel("A")
            ControlLabel("B")
            ControlLabel("C")
        }
        let output = element.markupString()
        #expect(output.contains("z-index: 0"))
        #expect(output.contains("z-index: 1"))
        #expect(output.contains("z-index: 2"))
    }

    @Test("ZStack topLeading alignment uses flex-start for both axes")
    func topLeadingAlignment() async throws {
        let element = ZStack(alignment: .topLeading) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self: flex-start"))
        #expect(output.contains("justify-self: flex-start"))
    }

    @Test("ZStack bottomTrailing alignment uses flex-end for both axes")
    func bottomTrailingAlignment() async throws {
        let element = ZStack(alignment: .bottomTrailing) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self: flex-end"))
        #expect(output.contains("justify-self: flex-end"))
    }

    @Test("ZStack top alignment uses flex-start for vertical and center for horizontal")
    func topAlignment() async throws {
        let element = ZStack(alignment: .top) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self: flex-start"))
        #expect(output.contains("justify-self: center"))
    }

    @Test("ZStack bottom alignment uses flex-end for vertical and center for horizontal")
    func bottomAlignment() async throws {
        let element = ZStack(alignment: .bottom) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self: flex-end"))
        #expect(output.contains("justify-self: center"))
    }

    @Test("ZStack leading alignment uses center for vertical and flex-start for horizontal")
    func leadingAlignment() async throws {
        let element = ZStack(alignment: .leading) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self: center"))
        #expect(output.contains("justify-self: flex-start"))
    }

    @Test("ZStack trailing alignment uses center for vertical and flex-end for horizontal")
    func trailingAlignment() async throws {
        let element = ZStack(alignment: .trailing) {
            ControlLabel("Item")
        }
        let output = element.markupString()
        #expect(output.contains("align-self: center"))
        #expect(output.contains("justify-self: flex-end"))
    }

}
