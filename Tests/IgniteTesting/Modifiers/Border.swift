//
//  Border.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `BorderModifier` modifier.
@Suite("BorderModifier Tests")
@MainActor
class BorderModifierTests: IgniteTestSuite {
    @Test("Border Modifier with All Edges")
    func borderWithAllEdges() async throws {
        let element = Text("Hello").border(.red, width: 2.0, style: .solid, edges: .all)
        let output = element.render()
        #expect(output == "<p style=\"border: 2.0px solid rgb(255 0 0 / 100%)\">Hello</p>")
    }

    @Test("Border Modifier with Specific Edges")
    func borderWithSpecificEdges() async throws {
        let element = Text("Hello").border(.blue, width: 1.0, style: .dotted, edges: [.top, .bottom])
        let output = element.render()
        #expect(output.contains("border-top: 1.0px dotted rgb(0 0 255 / 100%)"))
        #expect(output.contains("border-bottom: 1.0px dotted rgb(0 0 255 / 100%)"))
        #expect(!output.contains("border-left"))
        #expect(!output.contains("border-right"))
    }

    @Test("Border Modifier with Corner Radii")
    func borderWithCornerRadii() async throws {
        let element = Text("Hello").border(
            .green,
            width: 1.0,
            style: .dashed,
            cornerRadii: CornerRadii(
                topLeading: 5,
                topTrailing: 10,
                bottomLeading: 15,
                bottomTrailing: 20
            )
        )
        let output = element.render()
        #expect(output.contains("border-top-left-radius: 5px"))
        #expect(output.contains("border-top-right-radius: 10px"))
        #expect(output.contains("border-bottom-left-radius: 15px"))
        #expect(output.contains("border-bottom-right-radius: 20px"))
    }
}
