//
//  CornerRadius.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `CornerRadius` modifier.
@Suite("CornerRadius Tests")
@MainActor
class CornerRadiusTests: IgniteTestSuite {
    @Test("CornerRadius Modifier with All Edges (String)")
    func cornerRadiusWithAllEdgesString() async throws {
        let element = Text("Hello").cornerRadius(.percent(50%))
        let output = element.render()
        #expect(output == "<p style=\"border-radius: 50.0%\">Hello</p>")
    }

    @Test("CornerRadius Modifier with All Edges (Pixels)")
    func cornerRadiusWithAllEdgesPixels() async throws {
        let element = Text("Hello").cornerRadius(10)
        let output = element.render()
        #expect(output == "<p style=\"border-radius: 10px\">Hello</p>")
    }

    @Test("CornerRadius Modifier with Specific Edges (String)")
    func cornerRadiusWithSpecificEdgesString() async throws {
        let element = Text("Hello").cornerRadius([.topLeading, .bottomTrailing], .px(10))
        let output = element.render()
        #expect(output.contains("border-top-left-radius: 10px"))
        #expect(output.contains("border-bottom-right-radius: 10px"))
        #expect(!output.contains("border-top-right-radius"))
        #expect(!output.contains("border-bottom-left-radius"))
    }

    @Test("CornerRadius Modifier with Specific Edges (Pixels)")
    func cornerRadiusWithSpecificEdgesPixels() async throws {
        let element = Text("Hello").cornerRadius([.topLeading, .bottomTrailing], 10)
        let output = element.render()
        #expect(output.contains("border-top-left-radius: 10px"))
        #expect(output.contains("border-bottom-right-radius: 10px"))
        #expect(!output.contains("border-top-right-radius"))
        #expect(!output.contains("border-bottom-left-radius"))
    }
}
